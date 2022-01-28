//
//  HobbyCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

class HobbyTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = String(describing: HobbyTableViewCell.self)

    let titleLabel = Utility.managementLabel(text: "자주 하는 취미")
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.font = R.font.notoSansKRRegular(size: 14)
        return tf
    }()
    
    lazy var inputContainerView: UIView = {
        let view = Utility.inputContainerView(textField: inputTextField)
        return view
    }()
    
    var item: ManagementViewModelItem? {
        didSet {
            guard let item = item as? HobbyItem else { return }
            inputTextField.text = item.hobby
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHobbyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    private func setHobbyView() {
        [titleLabel, inputContainerView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(164)
        }
    }
}
