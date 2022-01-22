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
    
    let yearTextField = Utility.textField(withPlaceholder: "0000")
    let monthTextField = Utility.textField(withPlaceholder: "00")
    let dayTextField = Utility.textField(withPlaceholder: "00")
    
    lazy var yearTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: yearTextField)
        return view
    }()
    lazy var monthTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: monthTextField)
        return view
    }()
    lazy var dayTextFieldContainerView: UIView = {
        let view = Utility.inputContainerView(textField: dayTextField)
        return view
    }()
    
    private let titleLabel = Utility.label(text: "생년월일을 알려주세요", textColor: R.color.black(), fontSize: 20)
    private let yearLabel = Utility.label(text: "년", textColor: R.color.black(), fontSize: 16)
    private let monthLabel = Utility.label(text: "월", textColor: R.color.black(), fontSize: 16)
    private let dayLabel = Utility.label(text: "일", textColor: R.color.black(), fontSize: 16)
    
    let nextButton: UIButton = {
        let button = Utility.button()
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
        stack.distribution = .fillEqually
        
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
