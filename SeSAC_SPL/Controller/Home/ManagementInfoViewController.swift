//
//  ManagementInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

class ManagementInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let authViewModel = AuthViewModel()
    
    let withdrawButton: UIButton = {
        let button = Utility.button(backgroundColor: R.color.gray6())
        button.setTitle("회원 탈퇴", for: .normal)
        button.addTarget(self, action: #selector(withdrawButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "정보 관리"
        view.backgroundColor = .systemTeal
        
        view.addSubview(withdrawButton)
        withdrawButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Action
    
    // 회원 탈퇴 로직
    
    @objc func withdrawButtonClicked() {
        
        self.authViewModel.withdrawUser { error, statusCode in
            if let error = error {
                print(error); return
            }
            
            self.view.makeToast("회원 탈퇴 Code : \(statusCode ?? 0)", position: .center)
            
            // FCM 토큰 갱신
            self.authViewModel.updateFCMtoken { error, statusCode in
                switch statusCode {
                case 200:
                    print("\(statusCode ?? 0) 토큰 갱신 성공")
                    
                    self.view.makeToast("새롭게 가입해보세요!")
                    Helper.convertNavigationRootViewController(view: self.view, controller: VerificationViewController())
                    
                default:
                    print("Error Code:", statusCode ?? 0)
                }
            }
        }
    }
}
