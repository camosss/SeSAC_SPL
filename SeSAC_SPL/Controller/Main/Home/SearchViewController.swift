//
//  SearchViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var friends: SearchFriendResponse?
    var requests: SearchFriendRequest?
    
    let searchView = SearchView()
    let searchBar = UISearchBar()
    let viewModel = SearchViewModel()
    
    var addHobbyText = [String]()
    let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSearchBar()
        searchFriend()
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
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
        handleSearchBar()
    }
    
    private func handleSearchBar() {
        
        searchBar.rx.text
            .orEmpty
            .subscribe(onNext: { query in
                
                query.components(separatedBy: " ").forEach {
                    if $0.count > 8 {
                        self.view.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다", position: .center)
                    } else if self.viewModel.wantItems.contains($0) {
                        self.view.makeToast("이미 등록된 취미입니다", position: .center)
                    }
                }
                
                self.addHobbyText = query.components(separatedBy: " ").filter{ $0.isValidHobby() }

            }).disposed(by: disposeBag)
        
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                self.searchBar.text = nil
                
                self.addHobbyText.forEach { addHobby in
                    
                    if self.viewModel.wantItems.contains(addHobby) {
                        self.addHobbyText.remove(at: self.addHobbyText.firstIndex(of: addHobby)!)
                        
                    } else {
                        if (self.viewModel.wantItems.count + self.addHobbyText.count) > 8 {
                            
                            let limit = 8 - self.viewModel.wantItems.count
                            var addHobby = [String]()
                            
                            for idx in stride(from: 0, to: limit, by: 1) {
                                addHobby.append(self.addHobbyText[idx])
                            }
                            
                            addHobby.forEach {
                                self.viewModel.wantItems.append($0)
                            }
                            self.searchView.collectionView.reloadData()
                            self.view.makeToast("취미를 더 이상 추가할 수 없습니다", position: .center)
                            
                        } else {
                            self.addHobbyText.forEach {
                                self.viewModel.wantItems.append($0)
                            }
                            self.searchView.collectionView.reloadData()
                        }
                    }
                }
                
            }).disposed(by: disposeBag)
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
    
    private func setCellBtn(_ cell: SearchCollectionViewCell, border: CGColor?, text: UIColor?, btn: Bool) {
        cell.layer.borderColor = border
        cell.label.textColor = text
        cell.layer.borderWidth = 1
        cell.cornerRadius = 8
        cell.removeButton.isHidden = btn
    }
    
    private func searchFriend() {
        guard let requests = requests else { return }

        viewModel.searchFriend(region: requests.region, lat: requests.lat, long: requests.long) { friends, error, statusCode in
            if let friends = friends {
                self.friends = friends
                self.setSearchView()
            }
        }
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
                self.setCellBtn(cell, border: R.color.error()?.cgColor, text: R.color.error(), btn: true)
            case .hf:
                self.setCellBtn(cell, border: R.color.gray4()?.cgColor, text: R.color.black(), btn: true)
            }
        } else {
            self.setCellBtn(cell, border: R.color.green()?.cgColor, text: R.color.green(), btn: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {            
            let addHobbyCell = viewModel.aroundItems[indexPath.row].name
            
            // "내가 하고 싶은"에 추가
            if self.viewModel.wantItems.contains(addHobbyCell) {
                self.view.makeToast("이미 등록된 취미입니다", position: .center)
            } else if self.viewModel.wantItems.count >= 8 {
                self.view.makeToast("취미를 더 이상 추가할 수 없습니다", position: .center)
            } else {
                viewModel.aroundItems.remove(at: indexPath.row)
                self.viewModel.wantItems.append(addHobbyCell)
            }
            
            print(self.viewModel.aroundItems.count)

            self.searchView.collectionView.reloadData()
        } else {
            self.viewModel.wantItems.remove(at: indexPath.row)
            self.searchView.collectionView.reloadData()
            
        }
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
        return CGSize(width: label.frame.width + 50, height: 32)
    }
}
