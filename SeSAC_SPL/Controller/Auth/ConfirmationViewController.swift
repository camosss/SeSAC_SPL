//
//  ConfirmationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import FirebaseAuth

class ConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    
    var timer: Timer!
    var limitTime = 60
    
    private let timerLabel = Utility.label(text: "", textColor: R.color.green(), fontSize: 14)

    private let reSendButton: UIButton = {
        let button = Utility.button()
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
    }
    
    // MARK: - Action
    
    @objc func resendButtonClicked() {
        print("resend")
    }
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.delegate = self
        
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

// MARK: - AuthViewDelegate
extension ConfirmationViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        stopTimer()
        
        let controller = NickNameViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
