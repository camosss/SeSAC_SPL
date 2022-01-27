//
//  ManagementInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

// 테이블뷰셀 -> 스택뷰 -> 타이틀뷰 -> 콜렉션뷰
// contentView.isUserInteractionEnabled = true

class ManagementInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User

    let tableView = UITableView()
    
    let authViewModel = AuthViewModel()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "정보 관리"
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Helper
    
    func setUpTableView() {
        tableView.backgroundColor = .purple
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
