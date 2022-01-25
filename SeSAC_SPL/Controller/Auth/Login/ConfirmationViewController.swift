//
//  ConfirmationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift
import FirebaseAuth

import Alamofire

class ConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let authViewModel = AuthViewModel()
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
        
        Helper.handleButtonEvent(authView: authView, output: output, disposeBag: disposeBag) {
            self.getVerificationCode()
        }
    }
    
    func getVerificationCode() {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            self.view.makeToast("전화번호 인증을 실패했습니다.", position: .center); return
        }
        
        guard let verificationCode = authView.inputTextField.text else {
            self.view.makeToast("인증번호를 입력하세요.", position: .center); return
        }
        
        authViewModel.getVerificationCode(verificationID: verificationID, verificationCode: verificationCode) { _, error in
            if error != nil { self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요", position: .center); return }

            print("인증번호 받기 성공", verificationCode)

            self.authViewModel.getMyUserInfo { user, error, statusCode in
                switch statusCode {
                case 200:
                    print("\(statusCode ?? 0) 성공")
                    self.view.makeToast("이미 가입된 회원입니다.", position: .center)
                    self.authViewModel.convertRootViewController(view: self.view, controller: MyInfoViewController())

                case 201:
                    print("\(statusCode ?? 0) 미가입 유저")
                    self.view.makeToast("휴대폰 번호 인증에 성공했습니다.", position: .center)
                    self.authViewModel.convertRootViewController(view: self.view, controller: NickNameViewController())

                case 401:
                    print("\(statusCode ?? 0) Firebase Token Error")
                    self.authViewModel.getIDTokenRefresh {
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", position: .center); return
                    } onSuccess: {
                        print("토큰 갱신 성공")
                    }
                default:
                    print("Error Code:", statusCode ?? 0)
                }
            }
            self.stopTimer()
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
            self.view.makeToast("시간 초과로 휴대폰 번호 인증을 실패했습니다.", position: .center)
            self.timerLabel.isHidden = true
            self.timer.invalidate()
        }
    }
    
    func stopTimer() {
        self.timerLabel.isHidden = true
        self.timer.invalidate()
    }
}
