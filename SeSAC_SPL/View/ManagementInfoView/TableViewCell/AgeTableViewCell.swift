//
//  AgeTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class AgeTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = String(describing: AgeTableViewCell.self)
    
    let titleLabel = Utility.managementLabel(text: "상대방 연령대")
    
    let ageRangeLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.green())
        label.font = R.font.notoSansKRMedium(size: 14)
        return label
    }()
    
    let sliderView: UISlider = {
        let slider = Utility.sliderView()
        slider.addTarget(self, action: #selector(updateAgeValue), for: .valueChanged)
        return slider
    }()
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? AgeItem else { return }
            ageRangeLabel.text = "\(item.ageMin) - \(item.ageMax)"
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAgeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func updateAgeValue(_ sender: UISlider) {
        print(sender.value)
    }
    
    // MARK: - Helper
    
    private func setAgeView() {
        [titleLabel, ageRangeLabel, sliderView].forEach {
            contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
        }

        ageRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        sliderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(28)
        }
    }
}
