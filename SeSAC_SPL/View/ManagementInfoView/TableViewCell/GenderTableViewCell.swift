//
//  GenderTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: GenderTableViewCell.self)

    let titleLabel = Utility.label(text: "성별 title", textColor: .black)
    let subTitleLabel = Utility.label(text: "성별 sub", textColor: .lightGray)
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? GenderItem else { return }
            titleLabel.text = item.title
            subTitleLabel.text = "\(item.gender)"
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(10)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
