//
//  MyInfoView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

class MyInfoView: UIView {
    
    // MARK: - Properties
    
    let titleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.black())
        label.numberOfLines = 0
        return label
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
        [titleImageView, titleLabel].forEach {
            addSubview($0)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleImageView.snp.trailing).offset(13)
        }
    }
}
