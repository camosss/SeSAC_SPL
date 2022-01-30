//
//  ManagementInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

// ViewController에서는 오직 UI만 바꿔준다
class ManagementInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    var expand = false
    
    let tableView = UITableView()
    lazy var managementViewModel = ManagementViewModel(user: user, view: view, expand: expand)
    
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
        
        tableView.estimatedRowHeight = 310
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(BackImageTableViewCell.self, forCellReuseIdentifier: BackImageTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.identifier)
        tableView.register(HobbyTableViewCell.self, forCellReuseIdentifier: HobbyTableViewCell.identifier)
        tableView.register(AllowTableViewCell.self, forCellReuseIdentifier: AllowTableViewCell.identifier)
        tableView.register(AgeTableViewCell.self, forCellReuseIdentifier: AgeTableViewCell.identifier)
        tableView.register(WithdrawTabelViewCell.self, forCellReuseIdentifier: WithdrawTabelViewCell.identifier)
    }
}
