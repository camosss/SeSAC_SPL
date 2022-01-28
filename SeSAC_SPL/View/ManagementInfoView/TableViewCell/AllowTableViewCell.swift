//
//  AllowTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class AllowTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = String(describing: AllowTableViewCell.self)

    var searchable: Int?
    
    let titleLabel = Utility.managementLabel(text: "내 번호 검색 허용")

    let switchView: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = true
        switchDemo.addTarget(self, action: #selector(toggleSearchable), for: .valueChanged)
        return switchDemo
    }()
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? AllowItem else { return }
            print("setAllowView", item.searchable)
            searchable = item.searchable
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAllowView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func toggleSearchable() {
        if searchable == 0 { searchable = 1 } else { searchable = 0 }
    }
    
    // MARK: - Helper
    
    private func setAllowView() {
        [titleLabel, switchView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(52)
        }
    }
}
