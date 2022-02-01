//
//  MyInfoHeaderTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

class MyInfoHeaderTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: MyInfoHeaderTableViewCell.self)

    let myinfoView = MyInfoView()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = R.color.black()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()

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
        myinfoView.titleLabel.font = R.font.notoSansKRMedium(size: 16)
        myinfoView.titleImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        myinfoView.titleImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        [myinfoView, nextButton].forEach {
            addSubview($0)
        }
        
        myinfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(22.5)
        }
    }
    
    func updateUI(user: User, myInfo: MyInfo) {
        myinfoView.titleImageView.image = myInfo.image
        myinfoView.titleLabel.text = user.nick
    }
}
