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
        setSearchBar()
        searchFriend(region: region, lat: lat, long: long)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Action
    
    @objc func clickedSearchBtn() {
        print("btn")
    }
    
    // MARK: - Helper
    
    private func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
    }
    
    private func setSearchView() {
        searchView.searchButton.addTarget(self, action: #selector(clickedSearchBtn), for: .touchUpInside)

        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        searchView.collectionView.register(TitleCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func setCellBtn(_ cell: SearchCollectionViewCell, border: CGColor?, text: UIColor?) {
        cell.layer.borderColor = border
        cell.label.textColor = text
        cell.layer.borderWidth = 1
        cell.cornerRadius = 8
    }
    
    private func searchFriend(region: Int, lat: Double, long: Double) {
        viewModel.searchFriend(region: region, lat: lat, long: long) { friends, error, statusCode in
            if let friends = friends {
                self.friends = friends
                self.setSearchView()
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


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as! TitleCollectionViewHeader
        header.label.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.aroundItems.count : viewModel.wantItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        let aroundItems = viewModel.aroundItems[indexPath.row]
        cell.label.text = indexPath.section == 0 ? aroundItems.name : viewModel.wantItems[indexPath.row]
        
        if indexPath.section == 0 {
            switch aroundItems.type {
            case .recommend:
                self.setCellBtn(cell, border: R.color.error()?.cgColor, text: R.color.error())
            case .hf:
                self.setCellBtn(cell, border: R.color.gray4()?.cgColor, text: R.color.black())
            }
        } else {
            self.setCellBtn(cell, border: R.color.green()?.cgColor, text: R.color.green())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap cell")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    // 섹션 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    // Header View 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 34)
    }
    
    // Cell 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = indexPath.section == 0 ? viewModel.aroundItems[indexPath.row].name : viewModel.wantItems[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 30, height: 32)
    }
}
