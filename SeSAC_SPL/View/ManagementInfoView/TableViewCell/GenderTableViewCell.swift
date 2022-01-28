//
//  GenderTableViewCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: GenderTableViewCell.self)

    let titleLabel = Utility.managementLabel(text: "내 성별")
    
    
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? GenderItem else { return }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
