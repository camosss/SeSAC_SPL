//
//  AuthView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/19.
//

import UIKit
import SnapKit

protocol AuthViewDelegate: AnyObject {
    func handleNextButtonAction()
}

class AuthView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AuthViewDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.gray7()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    lazy var inputContainerView: UIView = {
        let view = Utility.inputContainerView(textField: inputTextField)
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.color.green()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
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
    
    // MARK: - Action
    
    @objc func nextButtonClicked() {
        delegate?.handleNextButtonAction()
    }
    
    // MARK: - Helper
    
    func setupConstraints() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(185)
            make.centerX.equalToSuperview()
        }
        
        addSubview(inputContainerView)
        inputContainerView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(76)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(inputContainerView.snp.bottom).offset(72)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
}
