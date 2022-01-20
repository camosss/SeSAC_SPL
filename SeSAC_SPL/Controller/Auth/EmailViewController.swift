//
//  EmailViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class EmailViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAuthView()
    }
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.delegate = self

        authView.titleLabel.text = "이메일을 입력해주세요"
        authView.subTitleLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        authView.inputTextField.placeholder = "SeSAC@email.com"
        authView.nextButton.setTitle("다음", for: .normal)
    }
}

// MARK: - AuthViewDelegate
extension EmailViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let controller = GenderViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
