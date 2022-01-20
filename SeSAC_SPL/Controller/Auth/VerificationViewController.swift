//
//  VerificationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class VerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    
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
        authView.subTitleLabel.isHidden = true
        
        authView.titleLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
        authView.inputTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        authView.nextButton.setTitle("인증 문자 받기", for: .normal)
    }
}

// MARK: - AuthViewDelegate

extension VerificationViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let controller = ConfirmationViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
