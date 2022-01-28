//
//  ManagementInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit
import RxSwift
import RxCocoa

class ManagementInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    var expand = false

    let tableView = UITableView()
    lazy var managementViewModel = ManagementViewModel(user: user, expand: expand)
    
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
        view.backgroundColor = .white
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Helper
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        tableView.dataSource = managementViewModel
        tableView.delegate = managementViewModel
        
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(BackImageTableViewCell.self, forCellReuseIdentifier: BackImageTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.identifier)
        tableView.register(HobbyTableViewCell.self, forCellReuseIdentifier: HobbyTableViewCell.identifier)
        tableView.register(AllowTableViewCell.self, forCellReuseIdentifier: AllowTableViewCell.identifier)
        tableView.register(AgeTableViewCell.self, forCellReuseIdentifier: AgeTableViewCell.identifier)
        tableView.register(WithdrawTabelViewCell.self, forCellReuseIdentifier: WithdrawTabelViewCell.identifier)
    }
    
    
    
    
    
    
    
    
    
    
    // 회원 탈퇴 로직
//    private func withdrawUserLogic() {
//        self.authViewModel.withdrawUser { error, statusCode in
//            if let error = error {
//                print(error); return
//            }
//
//            self.view.makeToast("회원 탈퇴 Code : \(statusCode ?? 0)", position: .center)
//
//            // FCM 토큰 갱신
//            self.authViewModel.updateFCMtoken { error, statusCode in
//                switch statusCode {
//                case 200:
//                    print("\(statusCode ?? 0) 토큰 갱신 성공")
//
//                    self.view.makeToast("새롭게 가입해보세요!")
//                    Helper.convertNavigationRootViewController(view: self.view, controller: VerificationViewController())
//
//                default:
//                    print("Error Code:", statusCode ?? 0)
//                }
//            }
//        }
//    }
}
