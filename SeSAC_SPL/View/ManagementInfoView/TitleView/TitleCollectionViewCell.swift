//
//  TitleCollectionViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TitleCollectionViewCell.self)
        
    let label: UILabel = {
        let label = UILabel()
        label.textColor = R.color.white()
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TitleTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as! TitleCollectionViewHeader
        header.label.text = indexPath.section == 0 ? "새싹 타이틀" : "새싹 리뷰"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? Utility.titles.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.label.text = Utility.titles[indexPath.row]
            cell.cornerRadius = 8
            
            let reputation = reputation[indexPath.row]
            cell.label.textColor = reputation == 0 ? R.color.black() : R.color.white()
            cell.backgroundColor = reputation == 0 ? R.color.white() : R.color.green()
            cell.layer.borderWidth = 1
            cell.layer.borderColor = reputation == 0 ? R.color.gray3()?.cgColor : R.color.green()?.cgColor
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleReviewCollectionViewCell.identifier, for: indexPath) as! TitleReviewCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView", indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TitleTableViewCell: UICollectionViewDelegateFlowLayout {
    
    // 셀 사이 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 8 : 0
    }
    
    // 행 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 6 : 0
    }
    
    // 섹션 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 24, right: 0)
    }

    // Header View 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 34)
    }

    // Cell 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let cellWidth = (width-40)/2
        return indexPath.section == 0 ? CGSize(width: (width-40)/2, height: cellWidth*0.2) : CGSize(width: width-32, height: 24)
    }

    // CollectionView 사이즈 조절 후, TableView UITableView.automaticDimension 적용
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

        self.titleCollectionView.layoutIfNeeded()
        
        let height = self.titleCollectionView.collectionViewLayout.collectionViewContentSize.height + CGFloat(50)
        return CGSize(width: targetSize.width, height: height)
    }
}
