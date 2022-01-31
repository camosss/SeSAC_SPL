//
//  GenderTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit
import RxSwift

class GenderTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()

    static let identifier = String(describing: GenderTableViewCell.self)
    
    let titleLabel = Utility.managementLabel(text: "내 성별")
    let manButton = Utility.genderButton(title: "남자")
    let womanButton = Utility.genderButton(title: "여자")
    
    lazy var buttonStackView = Utility.stackView(axis: .horizontal, spacing: 8, distribution: .fillProportionally, arrangedSubviews: [manButton, womanButton])
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? GenderItem else { return }

            if item.gender == 0 {
                womanButton.setTitleColor(R.color.white(), for: .normal)
                womanButton.backgroundColor = R.color.green()
            } else if item.gender == 1 {
                manButton.setTitleColor(R.color.white(), for: .normal)
                manButton.backgroundColor = R.color.green()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setGenderView()
        handleTapGenderBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    private func setGenderView() {
        [titleLabel, buttonStackView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
    }
    
    private func processTapBtn(value: Int, clicked: UIButton, unclicked: UIButton) {
        UserDefaults.standard.set(value, forKey: "gender")
        Helper.switchInfoButton(clicked, unclicked)
    }
    
    private func handleTapGenderBtn() {
        Observable.merge(
            manButton.rx.tap.map { _ in TapBtn.man },
            womanButton.rx.tap.map { _ in TapBtn.woman }
        ).subscribe(onNext: {
            switch $0 {
            case .man: self.processTapBtn(value: 1, clicked: self.manButton, unclicked: self.womanButton)
            case .woman: self.processTapBtn(value: 0, clicked: self.womanButton, unclicked: self.manButton)
            }
        }).disposed(by: disposeBag)
    }
    
}
