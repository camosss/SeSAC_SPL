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
    
    let yearTextField = Utility.birthTextField(withPlaceholder: "0000")
    let monthTextField = Utility.birthTextField(withPlaceholder: "00")
    let dayTextField = Utility.birthTextField(withPlaceholder: "00")
    
    lazy var yearTextFieldContainerView = Utility.inputContainerView(textField: yearTextField)
    lazy var monthTextFieldContainerView = Utility.inputContainerView(textField: monthTextField)
    lazy var dayTextFieldContainerView = Utility.inputContainerView(textField: dayTextField)
    
    private let titleLabel: UILabel = {
        let label = Utility.label(text: "생년월일을 알려주세요", textColor: R.color.black())
        label.font = R.font.notoSansKRRegular(size: 20)
        return label
    }()
    
    private let yearLabel = Utility.birthLabel(text: "년", textColor: R.color.black())
    private let monthLabel = Utility.birthLabel(text: "월", textColor: R.color.black())
    private let dayLabel = Utility.birthLabel(text: "일", textColor: R.color.black())
    
    let nextButton: UIButton = {
        let button = Utility.button(backgroundColor: R.color.gray6())
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - StackView
    
    lazy var yearStack = Utility.dateStackView([yearTextFieldContainerView, yearLabel])
    lazy var monthStack = Utility.dateStackView([monthTextFieldContainerView, monthLabel])
    lazy var dayStack = Utility.dateStackView([dayTextFieldContainerView, dayLabel])

    lazy var birthStack = Utility.stackView(axis: .horizontal, spacing: 10, distribution: .fillEqually, arrangedSubviews: [yearStack, monthStack, dayStack])
    
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
        [titleLabel, birthStack, nextButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(185)
            make.centerX.equalToSuperview()
        }
        
        birthStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(76)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(dayStack.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
