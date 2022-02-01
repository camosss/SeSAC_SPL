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
    let viewModel = GenderViewModel()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Helper
    
    private func configureAuthView() {
        authView.delegate = self
        authView.inputContainerView.isHidden = true
        
        authView.titleLabel.text = "성별을 선택해주세요"
        authView.subTitleLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        authView.nextButton.setTitle("다음", for: .normal)
    }
    
    private func configureGenderView() {
        authView.addSubview(genderStack)
        genderStack.snp.makeConstraints { make in
            make.top.equalTo(authView.subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func processTapBtn(value: Int, clicked: UIButton, unclicked: UIButton) {
        genderValue = value
        Helper.switchButton(clicked, unclicked)
        authView.nextButton.backgroundColor = R.color.green()
    }
    
    private func handleTapGenderBtn() {
        Observable.merge(
            manButton.rx.tap.map { _ in TapBtn.man },
            womanButton.rx.tap.map { _ in TapBtn.woman }
        ).subscribe(onNext: {
            switch $0 {
            case .man: self.processTapBtn(value: 1, clicked: self.manButton, unclicked: self.womanButton)
            case .woman: self.processTapBtn(value: 0, clicked: self.womanButton, unclicked: self.manButton)
            }
        }).disposed(by: disposeBag)
    }
    
    private func signUpUser(completion: @escaping () -> ()) {
        viewModel.signUpUserInfo { error, statusCode in
            switch statusCode {
            case 200:
                print("\(statusCode ?? 0) 회원가입 성공")
                self.view.makeToast("회원가입에 성공했습니다.", position: .center)
                completion()
                
            case 201:
                print("\(statusCode ?? 0) 이미 가입한 유저")
                self.view.makeToast("이미 가입한 유저입니다.", position: .center)
                completion()
                
            case 202:
                print("\(statusCode ?? 0) 사용할 수 없는 닉네임")
                self.view.makeToast("사용할 수 없는 닉네임입니다.\n닉네임 설정 화면으로 이동합니다.", position: .center)
                Helper.convertNavigationRootViewController(view: self.view, controller: NickNameViewController())

            case 401:
                print("\(statusCode ?? 0) Firebase Token Error")
                
            default:
                print("Error Code:", statusCode ?? 0)
            }
        }
    }
}

// MARK: - AuthViewDelegate

extension GenderViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        UserDefaults.standard.set(genderValue, forKey: "gender")
        
        self.signUpUser {
            Helper.convertRootViewController(view: self.view, controller: MainTapController())
        }
    }
}
