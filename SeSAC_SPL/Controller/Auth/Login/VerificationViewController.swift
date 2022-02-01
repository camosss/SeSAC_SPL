//
//  VerificationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import Toast_Swift
import RxSwift

class VerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let viewModel = VerificationViewModel()
    let disposeBag = DisposeBag()

    let onboardingService = OnboardingService()
    
    lazy var phoneNumber = Helper.makeRequestPhoneNumber(authView.inputTextField.text ?? "")

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayOnboardingView()
        configureAuthView()
        handleButtonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Action
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let phoneNum = authView.inputTextField.text ?? ""
        
        textField.text = phoneNum.count <= 12 ? phoneNum.toPhoneNumberPattern(pattern: "###-###-####", replacmentCharacter: "#") : phoneNum.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#")
    }
    
    // MARK: - Helper
    
    private func displayOnboardingView() {
        let onboardingVC = onboardingService.showOnboardingView()
        present(onboardingVC, animated: false)
    }
    
    private func configureAuthView() {
        view.backgroundColor = .white
        authView.subTitleLabel.isHidden = true
        
        authView.titleLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
        authView.inputTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        authView.nextButton.setTitle("인증 문자 받기", for: .normal)
        
        authView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func handleButtonEvent() {
        let input = VerificationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
        let output = viewModel.phoneNumberTransform(input: input)
        
        output.validStatus
            .map { $0 ? R.color.green() : R.color.gray6() }
            .bind(to: authView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.validStatus
            .bind(to: authView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.validText
            .asDriver()
            .drive(authView.inputTextField.rx.text)
            .disposed(by: disposeBag)

        output.sceneTransition
            .subscribe { _ in
                self.requestVerification {
                    let controller = ConfirmationViewController()
                    controller.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func requestVerification(completion: @escaping () -> ()) {
        viewModel.requestVerificationCode(phoneNumber: phoneNumber) { verificationID, error in
            if error == nil {
                print("verificationID: \(verificationID ?? "")")
                completion()
            } else {
                print("Phone Varification Error: \(error.debugDescription)")
                
                if error?.localizedDescription == "Invalid format." {
                    self.view.makeToast("유효하지 않은 전화번호 형식입니다.", position: .center)
                } else {
                    self.view.makeToast("에러가 발생했습니다.\n다시 시도해주세요", position: .center)
                }
            }
        }
    }
}
