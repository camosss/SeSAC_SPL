//
//  SearchDetailViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/13.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var requests: SearchFriendRequest?
    
    let viewModel = SearchDetailViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchFriend()
    }
    
    // MARK: - Helper
    
    private func searchFriend() {
        guard let requests = requests else { return }

        viewModel.searchFriend(region: requests.region, lat: requests.lat, long: requests.long) { friends, error, statusCode in
            if let friends = friends {
                print("[SearchDetail] friends", friends)
            }
        }
    }
    
}
