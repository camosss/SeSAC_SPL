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
        
        // UserDefaults 저장된 객체 목록
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
          print("\(key) = \(value) \n")
        }
    }
    
    @objc func withdrawButtonClicked() {
        APIService.withdrawSignUp(idToken: idToken) { statuscode, error in
            if let error = error {
                print(error); return
            }
            
            self.view.makeToast("회원 탈퇴 Code : \(statuscode ?? 0)", position: .center)
            UserDefaults.standard.string(forKey: "FCMToken")
            
            
        }
    }
}
