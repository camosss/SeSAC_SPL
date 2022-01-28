//
//  TitleCollectionViewHeader.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class TitleCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TitleCollectionViewHeader.self)

    let label = UILabel()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = R.font.notoSansKRRegular(size: 12)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
