//
//  GenderButton+Extension.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class GenderButton: UIButton {
    
    // MARK: - Properties
    
    let genderImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.notoSansKRRegular(size: 16)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(genderImageView)
        addSubview(genderLabel)
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = R.color.gray3()?.cgColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        genderImageView.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(genderImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
}
