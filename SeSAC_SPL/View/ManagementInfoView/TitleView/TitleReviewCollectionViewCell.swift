//
//  TitleReviewCollectionViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class TitleReviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TitleReviewCollectionViewCell.self)

    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "첫 리뷰를 기다리는 중이에요!"
        return tf
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
