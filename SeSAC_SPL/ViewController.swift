//
//  ViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/19.
//

import UIKit
import FirebaseAuth

// TODO
// 버튼 유효성 검사 (rx 적용)

class ViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var varificationCodeTextField: UITextField!
    
    // MARK: - Properties
    
    var timer: Timer!
    var limitTime = 60
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerLabel.isHidden = true
    }
    
    // MARK: - Helper
    
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
    
    // MARK: - Action
    
    @IBAction func handleSendButton(_ sender: UIButton) {
        self.startTimer()
        
        let phoneNumber = phoneNumberTextField.text ?? ""
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if error == nil {
                  print("verificationID: \(verificationID ?? "")")
                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              } else {
                  print("Phone Varification Error: \(error.debugDescription)")
              }
          }
    }
    
    @IBAction func handleDoneButton(_ sender: UIButton) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let verificationCode = varificationCodeTextField.text ?? ""
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { success, error in
            if error == nil {
                print("사용자 로그인!", success ?? "")
                self.stopTimer()
            } else {
                print("Login failed: \(error.debugDescription)")
            }
        }
    }
}


