//
//  AlertView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/30.
//

import UIKit

class AlertView: UIView {
    
    // MARK: - Properties

    let titleLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.black())
        label.font = R.font.notoSansKRMedium(size: 16)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.black())
        label.font = R.font.notoSansKRRegular(size: 14)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = Utility.button(setTitleColor: R.color.black(), backgroundColor: R.color.gray2())
        button.setTitle("취소", for: .normal)
        return button
    }()
    
    let okButton: UIButton = {
        let button = Utility.button(setTitleColor: R.color.white(), backgroundColor: R.color.green())
        button.setTitle("확인", for: .normal)
        return button
    }()
    
    lazy var buttonStack = Utility.stackView(axis: .horizontal, spacing: 8, distribution: .fillEqually, arrangedSubviews: [cancelButton, okButton])
    
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
        [titleLabel, subTitleLabel, buttonStack].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
