//
//  ManagementViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit

// ViewModel - Model을 업데이트하고 그 결과를 다시 받아서 View에 전달하여 UI를 업데이트

class ManagementViewModel: NSObject {
    
    var items = [ManagementViewModelItem]()
        
    var user: User
    var expand: Bool

    init(user: User, expand: Bool) {
        self.user = user
        self.expand = expand
        
        let background = BackgroundItem(background: user.background, sesac: user.sesac)
        let title = TitleItem(username: user.nick, reputation: user.reputation)
        let gender = GenderItem(gender: user.gender)
        let hobby = HobbyItem(hobby: user.hobby)
        let allow = AllowItem(searchable: user.searchable)
        let age = AgeItem(ageMin: user.ageMin, ageMax: user.ageMax)
        let withdraw = WithdrawItem()
        
        items.append(background)
        items.append(title)
        items.append(gender)
        items.append(hobby)
        items.append(allow)
        items.append(age)
        items.append(withdraw)
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

// MARK: - UITableViewDataSource

extension ManagementViewModel: UITableViewDataSource {
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
            cell.backgroundColor = R.color.gray3()
            cell.selectionStyle = .none
            return cell

        case .hobby:
            let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.backgroundColor = R.color.gray3()
            cell.selectionStyle = .none
            return cell
            
        case .allow:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowTableViewCell.identifier, for: indexPath) as! AllowTableViewCell
            cell.item = item
            cell.backgroundColor = R.color.gray3()
            cell.selectionStyle = .none
            return cell
            
        case .age:
            let cell = tableView.dequeueReusableCell(withIdentifier: AgeTableViewCell.identifier, for: indexPath) as! AgeTableViewCell
            cell.item = item
            cell.backgroundColor = R.color.gray3()
            cell.selectionStyle = .none
            return cell
            
        case .withdraw:
            let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawTabelViewCell.identifier, for: indexPath) as! WithdrawTabelViewCell
            cell.item = item
            cell.backgroundColor = R.color.gray3()
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ManagementViewModel: UITableViewDelegate {
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
