//
//  NickNameViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class NickNameViewController: UIViewController {
    
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
        authView.subTitleLabel.isHidden = true

        authView.titleLabel.text = "닉네임을 입력해주세요"
        authView.inputTextField.placeholder = "10자 이내로 입력"
        authView.nextButton.setTitle("다음", for: .normal)
    }
}

// MARK: - AuthViewDelegate
extension NickNameViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let controller = BirthViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
