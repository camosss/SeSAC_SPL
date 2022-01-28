//
//  WithdrawTabelViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class WithdrawTabelViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = String(describing: WithdrawTabelViewCell.self)

    let titleLabel = Utility.managementLabel(text: "회원탈퇴")
    
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
    }
    
}
