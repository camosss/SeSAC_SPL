//
//  MyInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import UIKit

class MyInfoViewController: UIViewController {
    
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
        
        let fcmtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nickName = UserDefaults.standard.string(forKey: "nickName") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        print("fcmtoken:",fcmtoken)
        print("phoneNumber:",phoneNumber)
        print("nickName:",nickName)
        print("birth:",birth)
        print("email:",email)
        print("gender:",gender)
        print("idToken:",idToken)
    }
    
    @objc func withdrawButtonClicked() {
        APIService.withdrawSignUp(idToken: idToken) { statuscode, error in
            self.view.makeToast("회원 탈퇴 Code : \(statuscode ?? 0)")
        }
    }
}
