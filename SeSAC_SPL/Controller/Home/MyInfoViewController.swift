//
//  MyInfoViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User?

    let tableView = UITableView()

    let authViewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내정보"
        view.backgroundColor = .white
        
        setUpTableView()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
    
    // MARK: - Helper
    
    private func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.register(MyInfoHeaderTableViewCell.self, forCellReuseIdentifier: MyInfoHeaderTableViewCell.identifier)
        tableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchUser() {
        authViewModel.getUserInfo { user, error, statusCode in
            if let user = user {
                self.user = user
                self.configureTableViewDataSource(user: user)
            }
        }
    }
    
    private func presentDetail() {
        guard let user = user else { return }

        let controler = ManagementInfoViewController(user: user)
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    private func configureTableViewDataSource(user: User) {
        var viewModel = MyInfoViewModel(user: user)
        
        viewModel.myinfos
            .asDriver()
            .drive(tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoHeaderTableViewCell.identifier, for: IndexPath.init(row: row, section: 0)) as! MyInfoHeaderTableViewCell
                    cell.updateUI(myInfo: item)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! MyInfoTableViewCell
                    cell.updateUI(myInfo: item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                if indexPath.row == 0 {
                    self?.presentDetail()
                }
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 96 : 74
    }
}
