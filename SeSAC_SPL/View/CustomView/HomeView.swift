//
//  HomeView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/04.
//

import UIKit
import MapKit

class HomeView: UIView {
    
    // MARK: - Properties
    
    let mapView = MKMapView()
    
    let centerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.annotation()
        return iv
    }()
    
    let actionButton = Utility.actionButton()
    
    let totalButton = Utility.mapGenderButton(title: "전체")
    let manButton = Utility.mapGenderButton(title: "남자")
    let womanButton = Utility.mapGenderButton(title: "여자")
    
    lazy var genderButtonStack = Utility.stackView(axis: .vertical, spacing: 0, distribution: .fillEqually, arrangedSubviews: [totalButton, manButton, womanButton])
    
    // 컨테이너뷰에 버튼 스택넣고 쉐도우
    
    let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.gps(), for: .normal)
        button.backgroundColor = R.color.white()
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()
    
    lazy var buttonView = Utility.stackView(axis: .vertical, spacing: 16, distribution: .fillProportionally, arrangedSubviews: [genderButtonStack, gpsButton])
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func setupConstraints() {
        genderButtonStack.clipsToBounds = true
        genderButtonStack.cornerRadius = 8
        gpsButton.cornerRadius = 8
        
        [mapView, actionButton, buttonView].forEach {
            addSubview($0)
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.addSubview(centerImageView)
        centerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.trailing.equalTo(-16)
            make.width.height.equalTo(64)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(16)
            make.width.equalTo(48)
            make.height.equalTo(208)
        }
    }
}
