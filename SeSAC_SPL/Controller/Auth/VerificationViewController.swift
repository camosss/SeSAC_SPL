//
//  VerificationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class VerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let disposeBag = DisposeBag()

    let onboardingService = OnboardingService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAuthView()
        handleButtonEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !appDelegate.hasAlreadyLaunched {
            appDelegate.sethasAlreadyLaunched()
            displayOnboardingView()
        }
    }
    
    // MARK: - Helper
    
    func displayOnboardingView() {
        let onboardingVC = onboardingService.showOnboardingView()
        present(onboardingVC, animated: false)
    }
    
    func configureAuthView() {
        authView.delegate = self
        authView.inputTextField.delegate = self
        authView.subTitleLabel.isHidden = true
        
        authView.titleLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
        authView.inputTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        authView.nextButton.setTitle("인증 문자 받기", for: .normal)
    }
    
    func handleButtonEvent() {
//        let input = VerificationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
//        let output = viewModel.transform(input: input)
//
//        output.validStatus
//            .map { $0 ? R.color.green() : R.color.gray6() }
//            .bind(to: authView.nextButton.rx.backgroundColor)
//            .disposed(by: disposeBag)
//
//        output.validStatus
//            .bind(to: authView.nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        output.validText
//            .asDriver()
//            .drive(authView.inputTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        output.sceneTransition
//            .subscribe { _ in
//                let controller = ConfirmationViewController()
//                self.navigationController?.pushViewController(controller, animated: true)
//            }.disposed(by: disposeBag)
    }
    
}

// MARK: - AuthViewDelegate

extension VerificationViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let phoneNumber = Utility.makeRequestPhoneNumber(authView.inputTextField.text ?? "")
        print(phoneNumber)
        
        let controller = ConfirmationViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.formatPhoneNumber(range: range, string: string)
        return false
    }
}
