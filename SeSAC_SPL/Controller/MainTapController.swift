//
//  MainTapController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

class MainTapController: UITabBarController {
    
    // MARK: - Properties
    
    let viewModel = AuthViewModel()
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewController(withUser: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    // MARK: - Helpers
    
    func fetchUser() {
        viewModel.getUserInfo { user, error, statusCode in
            self.user = user
        }
    }
    
    func configureViewController(withUser user: User) {
        let home = Helper.templateNavigationController(image: R.image.home()!, title: "홈", rootViewController: HomeViewController())
        let shop = Helper.templateNavigationController(image: R.image.shop()!, title: "새싹샵", rootViewController: ShopViewController())
        let friend = Helper.templateNavigationController(image: R.image.friend()!, title: "새싹친구", rootViewController: FriendViewController())
        let myInfo = Helper.templateNavigationController(image: R.image.myinfo()!, title: "내정보", rootViewController: MyInfoViewController(user: user))
        
        viewControllers = [myInfo, home, shop, friend]
    }
}
