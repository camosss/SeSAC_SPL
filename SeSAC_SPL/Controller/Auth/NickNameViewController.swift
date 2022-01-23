//
//  NickNameViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

class NickNameViewController: UIViewController {
    
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
        authView.subTitleLabel.isHidden = true

        authView.titleLabel.text = "닉네임을 입력해주세요"
        authView.inputTextField.placeholder = "10자 이내로 입력"
        authView.nextButton.setTitle("다음", for: .normal)
    }
    
    func handleButtonEvent() {
        
        let input = ValidationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
        let output = viewModel.nickNameTransform(input: input)
        
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
                let controller = BirthViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
    }
}
