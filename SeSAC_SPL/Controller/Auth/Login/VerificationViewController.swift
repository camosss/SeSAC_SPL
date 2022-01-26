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
        displayOnboardingView()
        configureAuthView()
        handleButtonEvent()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let phoneNum = authView.inputTextField.text ?? ""
        
        textField.text = phoneNum.count <= 12 ? phoneNum.toPhoneNumberPattern(pattern: "###-###-####", replacmentCharacter: "#") : phoneNum.toPhoneNumberPattern(pattern: "###-####-####", replacmentCharacter: "#")
    }
    
    // MARK: - Helper
    
    func displayOnboardingView() {
        let onboardingVC = onboardingService.showOnboardingView()
        present(onboardingVC, animated: false)
    }
    
    func configureAuthView() {
        view.backgroundColor = .white
        authView.subTitleLabel.isHidden = true
        
        authView.titleLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
        authView.inputTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        authView.nextButton.setTitle("인증 문자 받기", for: .normal)
        
        authView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func handleButtonEvent() {
        let input = ValidationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
        let output = viewModel.phoneNumberTransform(input: input)
        
        Helper.handleButtonEvent(authView: authView, output: output, disposeBag: disposeBag) {
            self.requestVerification {
                let controller = ConfirmationViewController()
                controller.phoneNumber = self.phoneNumber
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func requestVerification(completion: @escaping () -> ()) {
        authViewModel.requestVerificationCode(phoneNumber: phoneNumber) { verificationID, error in
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
