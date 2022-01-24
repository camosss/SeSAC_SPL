//
//  GenderViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

enum TapBtn {
    case man
    case woman
}

class GenderViewController: UIViewController {
    
    // MARK: - Properties
    
    var genderValue: Int = -1
    
    let authView = AuthView()
    let disposeBag = DisposeBag()
    
    let manButton: GenderButton = {
        let button = GenderButton()
        button.genderImageView.image = R.image.man()
        button.genderLabel.text = "남자"
        return button
    }()
    
    let womanButton: GenderButton = {
        let button = GenderButton()
        button.genderImageView.image = R.image.woman()
        button.genderLabel.text = "여자"
        return button
    }()
    
    lazy var genderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [manButton, womanButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAuthView()
        configureGenderView()
        handleTapGenderBtn()
    }
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.delegate = self
        authView.inputContainerView.isHidden = true
        
        authView.titleLabel.text = "성별을 선택해주세요"
        authView.subTitleLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        authView.nextButton.setTitle("다음", for: .normal)
    }
    
    func configureGenderView() {
        authView.addSubview(genderStack)
        genderStack.snp.makeConstraints { make in
            make.top.equalTo(authView.subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func handleTapGenderBtn() {
        Observable.merge(
            manButton.rx.tap.map { _ in TapBtn.man },
            womanButton.rx.tap.map { _ in TapBtn.woman }
        ).subscribe(onNext: {
            switch $0 {
            case .man:
                self.genderValue = 1
                Utility.switchButton(self.manButton, self.womanButton)
                print("Tap man btn", self.genderValue)
            case .woman:
                self.genderValue = 0
                Utility.switchButton(self.womanButton, self.manButton)
                print("Tap woman btn", self.genderValue)
            }
        }).disposed(by: disposeBag)
    }
    
    func handleButtonEvent() {
    
    }
}

// MARK: - AuthViewDelegate

extension GenderViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let controller = MyInfoViewController()
        
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
}
