//
//  BackgroundImageView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/27.
//

import UIKit

class BackgroundImageView: UIView {
    
    // MARK: - Properties

    let faceImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.sesac()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.background()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.cornerRadius = 8
        return iv
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
        addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backImageView.addSubview(faceImageView)
        faceImageView.snp.makeConstraints { make in
            make.top.equalTo(19)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
        }
    }
}
