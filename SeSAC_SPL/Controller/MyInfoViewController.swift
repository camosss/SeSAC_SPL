//
//  MyInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import UIKit
import Alamofire

class MyInfoViewController: UIViewController {
    
    let authViewModel = AuthViewModel()
    
    let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

    let withdrawButton: UIButton = {
        let button = Utility.button(backgroundColor: R.color.gray6())
        button.setTitle("회원 탈퇴", for: .normal)
        button.addTarget(self, action: #selector(withdrawButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(withdrawButton)
        withdrawButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
        
    }
    
    @objc func withdrawButtonClicked() {
        APIService.withdrawSignUp(idToken: idToken) { statuscode, error in
            if let error = error {
                print(error); return
            }
            
            self.view.makeToast("회원 탈퇴 Code : \(statuscode ?? 0)", position: .center)
            UserDefaults.standard.removeObject(forKey: "FCMToken")
            UserDefaults.standard.removeObject(forKey: "idToken")
            
            // FCM 토큰 갱신
            
            // 전화번호 입력으로 넘어가기 (온보딩)
            self.authViewModel.convertRootViewController(view: self.view, controller: VerificationViewController())
            
        }
    }
}
