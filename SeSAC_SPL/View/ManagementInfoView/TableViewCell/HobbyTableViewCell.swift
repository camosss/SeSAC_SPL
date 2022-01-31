//
//  HobbyCell.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit
import RxSwift

class HobbyTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    let disposeBag = DisposeBag()

    static let identifier = String(describing: HobbyTableViewCell.self)

    let titleLabel = Utility.managementLabel(text: "자주 하는 취미")
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "취미를 입력해주세요"
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
            UserDefaults.standard.set(item.hobby, forKey: "hobby")
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHobbyView()
        handleTextField()
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
    
    private func handleTextField() {
        inputTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                UserDefaults.standard.set(text, forKey: "hobby")
            }).disposed(by: disposeBag)
    }
}
