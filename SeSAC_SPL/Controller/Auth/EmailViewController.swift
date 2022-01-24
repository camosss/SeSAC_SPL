//
//  EmailViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

class EmailViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let viewModel = ValidationViewModel()
    let disposeBag = DisposeBag()
    
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
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.titleLabel.text = "이메일을 입력해주세요"
        authView.subTitleLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        authView.inputTextField.placeholder = "SeSAC@email.com"
        authView.nextButton.setTitle("다음", for: .normal)
    }
    
    func handleButtonEvent() {
        
        let input = ValidationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
        let output = viewModel.emailTransform(input: input)
        
        Utility.handleButtonEvent(authView: authView, output: output, disposeBag: disposeBag) {
            let controller = GenderViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
