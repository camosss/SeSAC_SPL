//
//  AgeTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit
import RangeSeekSlider

class AgeTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = String(describing: AgeTableViewCell.self)
    
    let titleLabel = Utility.managementLabel(text: "상대방 연령대")
    
    let ageRangeLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.green())
        label.font = R.font.notoSansKRMedium(size: 14)
        return label
    }()
    
    let sliderView: RangeSeekSlider = {
        let slider = RangeSeekSlider()
        slider.minValue = 18
        slider.maxValue = 65
        slider.selectedMinValue = 18
        slider.selectedMaxValue = 65
        slider.hideLabels = true
        slider.handleColor = R.color.green()
        slider.tintColor = R.color.gray2()
        slider.colorBetweenHandles = R.color.green()
        slider.handleBorderColor = R.color.white()
        slider.handleBorderWidth = 1
        return slider
    }()
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? AgeItem else { return }
            ageRangeLabel.text = "\(item.ageMin) - \(item.ageMax)"
            sliderView.selectedMinValue = CGFloat(item.ageMin)
            sliderView.selectedMaxValue = CGFloat(item.ageMax)
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
    
    // MARK: - Helper
    
    private func setAgeView() {
        sliderView.delegate = self

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
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(30)
        }
    }
}

// MARK: - RangeSeekSliderDelegate

extension AgeTableViewCell: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        ageRangeLabel.text = "\(Int(minValue)) - \(Int(maxValue))"
        UserDefaults.standard.set(Int(minValue), forKey: "ageMin")
        UserDefaults.standard.set(Int(maxValue), forKey: "ageMax")
    }
}
