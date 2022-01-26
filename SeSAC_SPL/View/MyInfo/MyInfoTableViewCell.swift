//
//  MyInfoTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit
// https://jellysong.tistory.com/112

class MyInfoTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "MyInfoTableViewCell"
    
    let myinfoView = MyInfoView()
    
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
        myinfoView.titleLabel.font = R.font.notoSansKRRegular(size: 16)
        myinfoView.titleImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        myinfoView.titleImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        addSubview(myinfoView)
        myinfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateUI(myInfo: MyInfo) {
        myinfoView.titleImageView.image = myInfo.image
        myinfoView.titleLabel.text = myInfo.item
    }
}
