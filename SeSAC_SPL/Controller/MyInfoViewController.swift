//
//  MyInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        let fcmtoken = UserDefaults.standard.string(forKey: "FCMToken")
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
        let verificationCompleted = UserDefaults.standard.string(forKey: "verificationCompleted")
        let nickName = UserDefaults.standard.string(forKey: "nickName")
        let birth = UserDefaults.standard.string(forKey: "birth")
        let email = UserDefaults.standard.string(forKey: "email")
        let gender = UserDefaults.standard.string(forKey: "gender")

        print("fcmtoken:",fcmtoken)
        print("phoneNumber:",phoneNumber)
        print("verificationCompleted:",verificationCompleted)
        print("nickName:",nickName)
        print("birth:",birth)
        print("email:",email)
        print("gender:",gender)
    }
}
