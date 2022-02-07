//
//  SearchCollectionViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: SearchCollectionViewCell.self)
        
    let label: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = R.font.notoSansKRRegular(size: 14)
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
