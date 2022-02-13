//
//  InputHobbyCollectionViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import UIKit

class InputHobbyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: InputHobbyCollectionViewCell.self)
        
    let label: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = R.font.notoSansKRRegular(size: 14)
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = R.color.green()
        return button
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [label, removeButton])
        stack.axis = .horizontal
        stack.spacing = 6.75
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
