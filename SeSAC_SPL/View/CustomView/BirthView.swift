//
//  BirthView.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

protocol BirthViewDelegate: AnyObject {
    func handleNextButtonAction()
}

class BirthView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: BirthViewDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일을 알려주세요"
        label.textColor = R.color.black()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let yearTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "0000"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let monthTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "00"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let dayTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "00"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    lazy var yearTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: yearTextField)
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    lazy var monthTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: monthTextField)
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    lazy var dayTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: dayTextField)
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        label.textColor = R.color.black()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.textColor = R.color.black()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.textColor = R.color.black()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(185)
            make.centerX.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [yearTextFieldContainerView, yearLabel, monthTextFieldContainerView, monthLabel, dayTextFieldContainerView, dayLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(76)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(72)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
}


