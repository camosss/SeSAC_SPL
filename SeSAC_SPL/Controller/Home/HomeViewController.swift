//
//  HomeViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

enum HomeFilter {
    case total
    case man
    case woman
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let homeView = HomeView()
    let regionInMeters: Double = 700
    let locationManager = CLLocationManager()
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    var friends = [FromQueueDB]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        checkLocationService()
        handleTapFilterBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Action
    
    @objc func clickedGpsBtn() {
        print("gps")
    }
    
    @objc func actionButtonTapped() {
        print("action")
    }
    
    // MARK: - Helper
    
    private func setView() {
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.frame = view.bounds
        
        homeView.gpsButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        homeView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func handleTapFilterBtn() {
        Observable.merge(
            homeView.totalButton.rx.tap.map { _ in HomeFilter.total }.startWith(HomeFilter.total),
            homeView.manButton.rx.tap.map { _ in HomeFilter.man },
            homeView.womanButton.rx.tap.map { _ in HomeFilter.woman }
        ).subscribe(onNext: {
            switch $0 {
            case .total: Helper.switchFilterButton(self.homeView.totalButton, self.homeView.manButton, self.homeView.womanButton)
            case .man: Helper.switchFilterButton(self.homeView.manButton, self.homeView.totalButton, self.homeView.womanButton)
            case .woman: Helper.switchFilterButton(self.homeView.womanButton, self.homeView.manButton, self.homeView.totalButton)
            }
        }).disposed(by: disposeBag)
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
        homeView.mapView.delegate = self
    }
    
    private func checkLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedWhenInUse:
            print("앱 사용중 허용")
            homeView.mapView.showsUserLocation = true // 현위치
            
//            centerViewOnUserLocation()
            defaultLocation() // 영등포 캠퍼스를 시작점으로 테스트
            
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
    
    // 위치 허용: 현 위치
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                             latitudinalMeters: regionInMeters,
                                                 longitudinalMeters: regionInMeters)
            homeView.mapView.setRegion(region, animated: true)
        }
    }
    
    // 위치 거부: 영등포 캠퍼스
    private func defaultLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: regionInMeters,
                                        longitudinalMeters: regionInMeters)
        homeView.mapView.setRegion(region, animated: true)
    }
    
    // 움직임에 따른 중앙 위치 (사용자가 현 위치를 이동할 때마다 서버에 요청하기 위함)
    private func getPinCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let region = Helper.convertRegion(lat: latitude, long: longitude)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.searchFriend(region: region, lat: latitude, long: longitude)
        }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func searchFriend(region: Int, lat: Double, long: Double) {
        viewModel.searchFriend(region: region, lat: lat, long: long) { friends, error, statusCode in
            if let friends = friends {
                self.friends = friends.fromQueueDB
                self.searchFriendAnnotations()
            }
        }
    }
    
    private func searchFriendAnnotations() {
        for location in friends {
            let friendsCoordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let friendsAnnotation = MKPointAnnotation()
            
            friendsAnnotation.coordinate = friendsCoordinate
            homeView.mapView.addAnnotation(friendsAnnotation)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization(status)
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        _ = getPinCenterLocation(for: mapView)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = homeView.mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = R.image.sesac0()
        annotationView?.frame.size = CGSize(width: 83, height: 83)

        return annotationView
    }
}
