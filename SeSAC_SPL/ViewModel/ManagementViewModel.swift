//
//  ManagementViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

// MARK: - Type

enum ManagementViewModelItemType {
    case background
    case title
    case gender
    case hobby
    case allow
    case age
    case withdraw
}

// MARK: - ManagementViewModelItem

protocol ManagementViewModelItem {
    var type: ManagementViewModelItemType { get }
    var rowCount: Int { get }
}

extension ManagementViewModelItem {
    var rowCount: Int {  return 1 }
}

// MARK: - ManagementViewModel

class ManagementViewModel: NSObject {
    
    var items = [ManagementViewModelItem]()
        
    var user: User
    var expand: Bool

    init(user: User, expand: Bool) {
        self.user = user
        self.expand = expand
        
        let background = BackgroundItem(background: user.background)
        items.append(background)
        
        let title = TitleItem(username: user.nick)
        items.append(title)
        
        let gender = GenderItem(title: "내 성별", gender: user.gender)
        items.append(gender)

        let hobby = HobbyItem(title: "자주 하는 취미", hobby: user.hobby)
        items.append(hobby)
        
        let allow = HobbyItem(title: "내 번호 검색 허용", hobby: user.hobby)
        items.append(allow)
        
        let age = HobbyItem(title: "상대방 연령대", hobby: user.hobby)
        items.append(age)
        
        let withdraw = HobbyItem(title: "회원 탈퇴", hobby: user.hobby)
        items.append(withdraw)
        
        print("items", items)
    }

    func fetchUserData() {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.getUserInfo(idToken: idToken) { user, error, statusCode in
            if let user = user {
                self.user = user
            }
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ManagementViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .background:
            let cell = tableView.dequeueReusableCell(withIdentifier: BackImageTableViewCell.identifier, for: indexPath) as! BackImageTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
        
        case .gender:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableViewCell.identifier, for: indexPath) as! GenderTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell

        case .hobby:
            let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .allow:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .age:
            let cell = tableView.dequeueReusableCell(withIdentifier: AgeTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .withdraw:
            let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawTabelViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            expand.toggle()
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .fade) // 해당 cell만 reload
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 210 : (indexPath.section == 1 ? (expand ? 310 : 58) : 74)
    }
}

// MARK: - Item

class BackgroundItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .background }
    
    var background: Int
    
    init(background: Int) {
        self.background = background
    }
}

class TitleItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .title }
    
    var username: String
    
    init(username: String) {
        self.username = username
    }
}

class GenderItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .gender }
    
    var title: String
    var gender: Int
    
    init(title: String, gender: Int) {
        self.title = title
        self.gender = gender
    }
}

class HobbyItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .hobby }
    
    var title: String
    var hobby: String
    
    init(title: String, hobby: String) {
        self.title = title
        self.hobby = hobby
    }
}

class AllowItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .allow }
    
    var title: String
    var gender: Int
    
    init(title: String, gender: Int) {
        self.title = title
        self.gender = gender
    }
}

class AgeItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .age }
    
    var title: String
    var gender: Int
    
    init(title: String, gender: Int) {
        self.title = title
        self.gender = gender
    }
}

class WithdrawItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .withdraw }
    
    var title: String
    var gender: Int
    
    init(title: String, gender: Int) {
        self.title = title
        self.gender = gender
    }
}
