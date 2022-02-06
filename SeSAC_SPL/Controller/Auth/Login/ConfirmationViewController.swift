//
//  ConfirmationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

class ConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    let viewModel = ConfirmationViewModel()
    let disposeBag = DisposeBag()
    
    var timer: Timer!
    var limitTime = 60
    
    var phoneNumber = ""
    
    private let timerLabel: UILabel = {
        let label = Utility.label(text: "", textColor: R.color.green())
        label.font = R.font.notoSansKRMedium(size: 14)
        return label
    }()

    private let reSendButton: UIButton = {
        let button = Utility.button(setTitleColor: R.color.white(), backgroundColor: R.color.green())
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Action
    
    @objc func resendButtonClicked() {
        stopTimer()
        
        viewModel.requestVerificationCode(phoneNumber: phoneNumber) { verificationID, error in
            if error == nil {
                print("verificationID: \(verificationID ?? "")")
                self.startTimer()
            } else {
                print("Phone Varification Error: \(error.debugDescription)")
                
                if error?.localizedDescription == "Invalid format." {
                    self.view.makeToast("유효하지 않은 전화번호 형식입니다. 다시 한번 입력해주세요.", position: .center)
                } else {
                    self.view.makeToast("인증번호를 다시한번 확인해주세요.", position: .center)
                }
            }
        }
    }
    
    // MARK: - Helper
    
    private func configureAuthView() {
        authView.titleLabel.text = "인증번호가 문자로 전송되었어요"
        authView.subTitleLabel.text = "(최대 소모 20초)"
        authView.inputTextField.placeholder = "인증번호 입력"
        authView.nextButton.setTitle("인증하고 시작하기", for: .normal)
    }
    
    private func configureConfirmationView() {
        view.backgroundColor = .white
        [reSendButton, timerLabel].forEach {
            view.addSubview($0)
        }
        
        reSendButton.snp.makeConstraints { make in
            make.top.equalTo(authView.inputContainerView)
            make.trailing.equalTo(-16)
            make.width.equalTo(72)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(reSendButton.snp.leading).offset(-20)
            make.centerY.equalTo(authView.inputContainerView)
        }
    }
    
    private func handleButtonEvent() {
        let input = ConfirmationViewModel.Input(text: authView.inputTextField.rx.text, tap: authView.nextButton.rx.tap)
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
                self.getVerificationCode()
            }.disposed(by: disposeBag)
    }
    
    private func getVerificationCode() {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            self.view.makeToast("전화번호 인증을 실패했습니다.", position: .center); return
        }
        
        guard let verificationCode = authView.inputTextField.text else {
            self.view.makeToast("인증번호를 입력하세요.", position: .center); return
        }
        
        viewModel.getVerificationCode(verificationID: verificationID, verificationCode: verificationCode) { _, error in
            if error != nil { self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요", position: .center); return }

            self.viewModel.getUserInfo { user, error, statusCode in
                switch statusCode {
                case 200:
                    print("\(statusCode ?? 0) 성공")
                    self.view.makeToast("이미 가입된 회원입니다.", position: .center)
                    Helper.convertRootViewController(view: self.view, controller: MainTapController())

                case 406:
                    print("\(statusCode ?? 0) 미가입 유저")
                    self.view.makeToast("휴대폰 번호 인증에 성공했습니다.", position: .center)
                    Helper.convertNavigationRootViewController(view: self.view, controller: NickNameViewController())
                    
                case 401:
                    print("\(statusCode ?? 0) Firebase Token Error")
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", position: .center); return
                    
                default:
                    print("Error Code:", statusCode ?? 0)
                }
            }
            self.stopTimer()
        }
    }
    
    // MARK: - Helper (Timer)
    
    private func startTimer() {
        self.timerLabel.isHidden = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.limitTime -= 1
            self.updateTimerLabel()
        })
    }
    
    private func updateTimerLabel() {
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
    
    private func stopTimer() {
        timer.invalidate()
        limitTime = 60
    }
}
