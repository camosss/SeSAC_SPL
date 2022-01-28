//
//  TitleTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/27.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TitleTableViewCell.self)
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? TitleItem else { return }
            usernameLabel.text = item.username
        }
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.black()
        label.font = R.font.notoSansKRMedium(size: 16)
        return label
    }()
    
    var expandImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.down")
        image.tintColor = R.color.black()
        return image
    }()
    
    lazy var stackView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.cornerRadius = 8
        view.layer.borderColor = R.color.gray3()?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.register(TitleReviewCollectionViewCell.self, forCellWithReuseIdentifier: TitleReviewCollectionViewCell.identifier)
        collectionView.register(TitleCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleCollectionViewHeader.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    private func setTitleView() {
        [usernameLabel, expandImageView, collectionView].forEach {
            stackView.addSubview($0)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
        }

        expandImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(6)
            make.top.equalTo(26)
            make.trailing.equalToSuperview().inset(26)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
