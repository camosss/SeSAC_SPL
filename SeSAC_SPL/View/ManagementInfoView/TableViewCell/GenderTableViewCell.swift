//
//  GenderTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: GenderTableViewCell.self)

    var gender: Int?
    
    let titleLabel = Utility.managementLabel(text: "내 성별")
    let manButton = Utility.genderButton(title: "남자")
    let womanButton = Utility.genderButton(title: "여자")
    
    lazy var buttonStackView = Utility.stackView(axis: .horizontal, spacing: 8, distribution: .fillProportionally, arrangedSubviews: [manButton, womanButton])
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? GenderItem else { return }
            gender = item.gender
            
            if item.gender == 0 {
                womanButton.setTitleColor(.white, for: .normal)
                womanButton.backgroundColor = R.color.green()
            } else if item.gender == 1 {
                manButton.setTitleColor(.white, for: .normal)
                manButton.backgroundColor = R.color.green()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setGenderView()
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
    
}
