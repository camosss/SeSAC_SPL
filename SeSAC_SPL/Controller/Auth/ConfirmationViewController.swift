//
//  ConfirmationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift
import FirebaseAuth

class ConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let viewModel = ValidationViewModel()
    let disposeBag = DisposeBag()
    
    var timer: Timer!
    var limitTime = 60
    
    private let timerLabel = Utility.label(text: "", textColor: R.color.green(), fontSize: 14)

    private let reSendButton: UIButton = {
        let button = Utility.button(backgroundColor: R.color.green())
        button.setTitle("재전송", for: .normal)
        button.addTarget(self, action: #selector(resendButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuthView()
        configureConfirmationView()
        startTimer()
        handleButtonEvent()
    }
    
    // MARK: - Action
    
    @objc func resendButtonClicked() {
        print("resend")
    }
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.titleLabel.text = "인증번호가 문자로 전송되었어요"
        authView.subTitleLabel.text = "(최대 소모 20초)"
        authView.inputTextField.placeholder = "인증번호 입력"
        authView.nextButton.setTitle("인증하고 시작하기", for: .normal)
    }
    
    func configureConfirmationView() {
        view.backgroundColor = .white

        authView.addSubview(reSendButton)
        reSendButton.snp.makeConstraints { make in
            make.top.equalTo(authView.inputContainerView)
            make.trailing.equalTo(-16)
            make.width.equalTo(72)
        }
        
        authView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(reSendButton.snp.leading).offset(-20)
            make.centerY.equalTo(authView.inputContainerView)
        }
    }
    
    func handleButtonEvent() {
        
        let input = ValidationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
        let output = viewModel.certificationTransform(input: input)
        
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
                let controller = NickNameViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Helper (Timer)
    
    func startTimer() {
        timerLabel.isHidden = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.limitTime -= 1
            self.updateTimerLabel()
        })
    }
    
    func updateTimerLabel() {
        let minutes = self.limitTime / 60
        let seconds = self.limitTime % 60
        
        if self.limitTime > 0 {
            self.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            self.timerLabel.isHidden = true
            self.timer.invalidate()
        }
    }
    
    func stopTimer() {
        self.timerLabel.isHidden = true
        self.timer.invalidate()
    }
}
