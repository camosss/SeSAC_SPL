//
//  InputHobbyController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import UIKit
import RxSwift

class InputHobbyController: UIViewController {
    
    // MARK: - Properties
    
    var friends: SearchFriendResponse?
    var requests: SearchFriendRequest?
    
    let inputHobbyView = InputHobbyView()
    let searchBar = UISearchBar()
    let viewModel = InputHobbyViewModel()
    
    var addHobbyText = [String]()
    let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = inputHobbyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSearchBar()
        searchFriend()
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
    
    @objc func clickedSearchBtn() {
        viewModel.findFriend(type: 2, region: requests?.region ?? 0, lat: requests?.lat ?? 0, long: requests?.long ?? 0, hf: viewModel.wantItems) { error, statusCode in
            print(statusCode ?? 0)
            switch statusCode {
            case 200:
                let controller = SearchViewController()
                controller.requests = SearchFriendRequest(region: self.requests?.region ?? 0, lat: self.requests?.lat ?? 0, long: self.requests?.long ?? 0)
                self.navigationController?.pushViewController(controller, animated: true)
            case 201:
                self.view.makeToast("신고가 누적되어 이용하실 수 없습니다", position: .center)
            case 204:
                self.view.makeToast("약속 취소 패널티로, 1분동안 이용하실 수 없습니다", position: .center)
            case 205:
                self.view.makeToast("연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다", position: .center)
            case 206:
                self.view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!", position: .center)
                
                self.viewModel.getUserInfo { user, error, statusCode in
                    if let user = user {
                        let controller = ManagementInfoViewController(user: user)
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            default:
                // 취미를 하나도 등록 하지 않은 경우에는, “Anything” 가 추가된 배열을 내부적으로 서버에 보냅니다.
                print("[ViewModel]findFriend", statusCode ?? 0)
            }
        }
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
                            self.inputHobbyView.collectionView.reloadData()
                            self.view.makeToast("취미를 더 이상 추가할 수 없습니다", position: .center)
                            
                        } else {
                            self.addHobbyText.forEach {
                                self.viewModel.wantItems.append($0)
                            }
                            self.inputHobbyView.collectionView.reloadData()
                        }
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func setSearchView() {
        inputHobbyView.searchButton.addTarget(self, action: #selector(clickedSearchBtn), for: .touchUpInside)

        inputHobbyView.collectionView.dataSource = self
        inputHobbyView.collectionView.delegate = self
        
        inputHobbyView.collectionView.register(InputHobbyCollectionViewCell.self, forCellWithReuseIdentifier: InputHobbyCollectionViewCell.identifier)
        inputHobbyView.collectionView.register(TitleCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func setCellBtn(_ cell: InputHobbyCollectionViewCell, border: CGColor?, text: UIColor?, btn: Bool) {
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

extension InputHobbyController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputHobbyCollectionViewCell.identifier, for: indexPath) as! InputHobbyCollectionViewCell
        
        let aroundItems = viewModel.aroundItems[indexPath.row]
//        print(aroundItems)
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
//            print(self.viewModel.aroundItems.count)
            // "내가 하고 싶은"에 추가
            if self.viewModel.wantItems.contains(addHobbyCell) {
                self.view.makeToast("이미 등록된 취미입니다", position: .center)
            } else if self.viewModel.wantItems.count >= 8 {
                self.view.makeToast("취미를 더 이상 추가할 수 없습니다", position: .center)
            } else {
                viewModel.aroundItems.remove(at: indexPath.row)
                self.viewModel.wantItems.append(addHobbyCell)
            }
            
            self.inputHobbyView.collectionView.reloadData()
            
        } else {
            self.viewModel.wantItems.remove(at: indexPath.row)
            self.inputHobbyView.collectionView.reloadData()
            
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension InputHobbyController: UICollectionViewDelegateFlowLayout {
    
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
