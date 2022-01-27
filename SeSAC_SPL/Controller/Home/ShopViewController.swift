//
//  ShopViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import UIKit

class ShopViewController: UIViewController {
    
    // MARK: - Helper
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새싹샵"
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMoniter()
    }
}
