//
//  VerificationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import Toast_Swift

import RxSwift
import RxCocoa
import FirebaseAuth

class VerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let authViewModel = AuthViewModel()
    let viewModel = ValidationViewModel()
    let disposeBag = DisposeBag()

    let onboardingService = OnboardingService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var phoneNumber = Helper.makeRequestPhoneNumber(authView.inputTextField.text ?? "")

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAuthView()
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
    
    func requestVerification(completion: @escaping () -> ()) {
        authViewModel.requestVerificationCode(phoneNumber: phoneNumber) { verificationID, error in
            if error == nil {
                print("verificationID: \(verificationID ?? "")")
                completion()
            } else {
                print("Phone Varification Error: \(error.debugDescription)")
                
                if error?.localizedDescription == "Invalid format." {
                    self.view.makeToast("유효하지 않은 전화번호 형식입니다. 다시 한번 입력해주세요.")
                } else {
                    self.view.makeToast("에러가 발생했습니다.\n다시 시도해주세요")
                }
            }
        }
    }
}

// MARK: - AuthViewDelegate

extension VerificationViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        print("phoneNumber \(phoneNumber)")
        
        requestVerification {
            let controller = ConfirmationViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.formatPhoneNumber(range: range, string: string)
        return false
    }
}
