//
//  SearchViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/12.
//

import UIKit
import Tabman
import Pageboy

class SearchViewController: TabmanViewController {
    
    // MARK: - Properties
    
    private var viewControllers: Array<UIViewController> = []

    var requests: SearchFriendRequest?
    let viewModel = SearchViewModel()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새싹 찾기"
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기 중단", style: .plain, target: self, action: #selector(stopSearch))

        setTabman()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Action
    
    @objc func stopSearch() {
        viewModel.stopFindFriend { error, statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.set(1, forKey: "floatingButton")
                self.navigationController?.popViewController(animated: true)
            default:
                self.view.makeToast("새싹 찾기 중단을 실패하였습니다.")
            }
        }
    }
    
    // MARK: - Helper
    
    private func setTabman() {
        configureViewControllers()
        self.dataSource = self

        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        addBar(bar, dataSource: self, at: .top)

        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.indicator.tintColor = R.color.green()

        bar.buttons.customize { button in
            button.selectedTintColor =  R.color.green()
            button.tintColor = R.color.gray6()
        }
    }
    
    private func configureViewControllers() {
        let aroundVC = SearchDetailViewController.init(nibName: nil, bundle: nil)
        let receivedVC = SearchDetailViewController.init(nibName: nil, bundle: nil)
        
        viewControllers.append(aroundVC)
        viewControllers.append(receivedVC)
    }
}

// MARK: - PageboyViewControllerDataSource, TMBarDataSource

extension SearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            return TMBarItem(title: "\(index)")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let vc = viewControllers[index] as? SearchDetailViewController
        vc?.requests = requests
        return vc
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
