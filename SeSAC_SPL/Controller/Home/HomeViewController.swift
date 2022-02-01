//
//  HomeViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()

    let regionInMeters: Double = 700
    
    let buttonView = MapButtonView()
    
    private let actionButton: UIButton = {
        let button = Utility.actionButton()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setMapView()
        checkLocationService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Action
    
    @objc func actionButtonTapped() {
        print("action")
    }
    
    // MARK: - Helper
    
    private func setMapView() {
        [mapView, actionButton, buttonView].forEach {
            view.addSubview($0)
        }
        mapView.frame = view.bounds
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalTo(-16)
            make.width.height.equalTo(64)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(16)
            make.width.equalTo(48)
            make.height.equalTo(208)
        }
    }
    
    private func setAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    private func checkLocationService() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) { authorizationStatus = locationManager.authorizationStatus }
        else { authorizationStatus = CLLocationManager.authorizationStatus() }
        
        if CLLocationManager.locationServicesEnabled() {
            setupLoactionManager()
            checkLocationAuthorization(authorizationStatus)
        } else {
            // 권한 요청 알림
        }
    }
    
    private func setupLoactionManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
        mapView.delegate = self
    }
    
    private func checkLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedWhenInUse:
            print("앱 사용중 허용")
            mapView.showsUserLocation = true // 현위치
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            print("권한 요청 거부")
            defaultLocation()
            
        case .notDetermined:
            print("결정되지 않음 -> 권한 요청")
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways:
            print("항상 허용")
        default:
            print("GPS: Default")
        }
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                             latitudinalMeters: regionInMeters,
                                                 longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
            setAnnotation(location: location)
        }
    }
    
    private func defaultLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: regionInMeters,
                                        longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)

        setAnnotation(location: coordinate)
    }

}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization(status)
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = R.image.annotation()
        return annotationView
    }
}
