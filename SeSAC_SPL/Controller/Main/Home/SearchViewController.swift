//
//  SearchViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var friends: SearchFriendResponse?
    
    var region: Int
    var lat: Double
    var long: Double
    
    let searchView = SearchView()
    let searchBar = UISearchBar()
    let viewModel = SearchViewModel()

    // MARK: - Lifecycle
    
    init(region: Int, lat: Double, long: Double) {
        self.region = region
        self.lat = lat
        self.long = long
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchView.searchButton.addTarget(self, action: #selector(clickedSearchBtn), for: .touchUpInside)
        
        setSearchBar()
        searchFriend(region: region, lat: lat, long: long)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Action
    
    @objc func clickedSearchBtn() {
        print("btn")
    }
    
    // MARK: - Helper
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
    }
    
    private func searchFriend(region: Int, lat: Double, long: Double) {
        viewModel.searchFriend(region: region, lat: lat, long: long) { friends, error, statusCode in
            if let friends = friends {
                // rx로 값받아오기 [recommend]
                self.friends = friends
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 취미 조건 최소 1자리 최대 8자리
        // “최소 한 자 이상, 최대 8글자까지 작성 가능합니다” 토스트 메시지
        // [내가 하고 싶은] 섹션에 이미 8개의 취미가 등록되어 있다면, “취미를 더 이상 추가할 수 없습니다” 토스트 메시지
        // 여러 단어를 입력할 경우 띄워쓰기 기준으로 취미가 추가
        
    }
}
