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
    
    var gender: Int {
        switch self {
        case .total: return 2
        case .man: return 1
        case .woman: return 0
        }
    }
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
        
    let homeView = HomeView()
    let regionInMeters: Double = 700
    let locationManager = CLLocationManager()
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    var friends = [FromQueueDB]()
    
    let authorizationStatus = UserDefaults.standard.bool(forKey: "authorizationStatus")

    var region: Int?
    var lat: Double?
    var long: Double?

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        checkLocationService()
        handleTapFilterBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
        setActionBtn()
    }
    
    // MARK: - Action
    
    @objc func clickedGpsBtn() {
        if authorizationStatus {
            //centerViewOnUserLocation()
            defaultLocation() // 영등포 캠퍼스를 시작점으로 테스트
        } else {
            self.view.makeToast("위치 서비스 권한을 허용해주세요.", position: .center)
        }
    }
    
    @objc func actionButtonTapped() {
        viewModel.getUserInfo { user, error, statusCode in
            if let user = user {
                if user.gender == -1 {
                    self.view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!", position: .center)
                    
                    let controller = ManagementInfoViewController(user: user)
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else if !self.authorizationStatus {
                    self.view.makeToast("위치 서비스 권한을 허용해주세요.", position: .center)
                    
                } else {
                    let floating = UserDefaults.standard.integer(forKey: "floatingButton")
                    print(floating)
                    switch floating {
                    case 0:
                        if let region = self.region, let lat = self.lat, let long = self.long {
                            let controller = InputHobbyController()
                            controller.requests = SearchFriendRequest(region: region, lat: lat, long: long)
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    case 1:
                        print("새싹 찾기 화면(1_3_near_user)으로 전환")

                        let controller = SearchViewController()
                        self.navigationController?.pushViewController(controller, animated: true)

                    case 2:
                        print("채팅 화면(1_5_chatting)으로 전환")
                    default:
                        print("floating default")
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Helper
    
    private func setView() {
        homeView.gpsButton.addTarget(self, action: #selector(clickedGpsBtn), for: .touchUpInside)
        homeView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func setActionBtn() {
        // 플로팅 버튼 분기 처리
        let floating = UserDefaults.standard.integer(forKey: "floatingButton")

        // 일반 상태(1): 검색 아이콘, 매칭 대기중 상태(2): 와이파이 아이콘, 매칭된 상태(3): 메시지 아이콘
        switch floating {
        case 0: homeView.actionButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        case 1: homeView.actionButton.setImage(UIImage(systemName: "antenna.radiowaves.left.and.right"), for: .normal)
        case 2: homeView.actionButton.setImage(UIImage(systemName: "envelope"), for: .normal)
        default: homeView.actionButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
    }
    
    private func handleTapFilterBtn() {
        Observable.merge(
            homeView.totalButton.rx.tap.map { _ in HomeFilter.total }.startWith(HomeFilter.total),
            homeView.manButton.rx.tap.map { _ in HomeFilter.man },
            homeView.womanButton.rx.tap.map { _ in HomeFilter.woman }
        ).subscribe(onNext: {
            switch $0 {
            case .total:
                Helper.switchFilterButton(self.homeView.totalButton, self.homeView.manButton, self.homeView.womanButton)
                self.searchFriendAllAnnotations()
                
            case .man:
                Helper.switchFilterButton(self.homeView.manButton, self.homeView.totalButton, self.homeView.womanButton)
                self.searchFriendGenderAnnotations($0.gender)

            case .woman:
                Helper.switchFilterButton(self.homeView.womanButton, self.homeView.manButton, self.homeView.totalButton)
                self.searchFriendGenderAnnotations($0.gender)
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
            UserDefaults.standard.set(true, forKey: "authorizationStatus")
        } else {
            self.view.makeToast("위치 서비스 권한을 허용해주세요.", position: .center)
            UserDefaults.standard.set(false, forKey: "authorizationStatus")
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
            
            //centerViewOnUserLocation()
            defaultLocation() // 영등포 캠퍼스를 시작점으로 테스트
            
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            print("권한 요청 거부")
            defaultLocation()
            
        case .notDetermined:
            print("결정되지 않음 -> 권한 요청")
            locationManager.requestWhenInUseAuthorization()
            
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
            self.region = region
            self.lat = latitude
            self.long = longitude

            self.searchFriend(region: region, lat: latitude, long: longitude)
        }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func searchFriend(region: Int, lat: Double, long: Double) {
        viewModel.searchFriend(region: region, lat: lat, long: long) { friends, error, statusCode in
            if let friends = friends {
                self.friends = friends.fromQueueDB
                self.searchFriendAllAnnotations()
            }
        }
    }
    
    private func searchFriendAllAnnotations() {
        let annotations = homeView.mapView.annotations
        homeView.mapView.removeAnnotations(annotations)
        
        for location in friends {
            let friendsCoordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let friendsAnnotation = MKPointAnnotation()
            
            friendsAnnotation.coordinate = friendsCoordinate
            homeView.mapView.addAnnotation(friendsAnnotation)
        }
    }
    
    private func searchFriendGenderAnnotations(_ gender: Int) {
        let annotations = homeView.mapView.annotations
        homeView.mapView.removeAnnotations(annotations)
        
        for location in friends {
            if location.gender == gender {
                let friendsCoordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
                let friendsAnnotation = MKPointAnnotation()
                
                friendsAnnotation.coordinate = friendsCoordinate
                homeView.mapView.addAnnotation(friendsAnnotation)
            }
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
        
        // friends.sesac 값에 따른 이미지 분기처리
        annotationView?.image = R.image.sesac0()
        annotationView?.frame.size = CGSize(width: 83, height: 83)
        return annotationView
    }
}
