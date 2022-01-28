//
//  BackImageTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/27.
//

import UIKit

class BackImageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: BackImageTableViewCell.self)
    
    let backgroundImageView = BackgroundImageView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setMyInfoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func setMyInfoView() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
