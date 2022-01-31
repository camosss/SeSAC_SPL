//
//  MapButtonView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/31.
//

import UIKit

class MapButtonView: UIView {
    
    // MARK: - Properties
    
    let totalButton = Utility.mapGenderButton(title: "전체")
    let manButton = Utility.mapGenderButton(title: "남자")
    let womanButton = Utility.mapGenderButton(title: "여자")
    
    lazy var genderButtonStack = Utility.stackView(axis: .vertical, spacing: 0, distribution: .fillEqually, arrangedSubviews: [totalButton, manButton, womanButton])
    
    let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.gps(), for: .normal)
        button.backgroundColor = R.color.white()
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()
    
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
        addSubview(genderButtonStack)
        genderButtonStack.clipsToBounds = true
        genderButtonStack.cornerRadius = 8
        genderButtonStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(gpsButton)
        gpsButton.cornerRadius = 8
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(genderButtonStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
    }
}
