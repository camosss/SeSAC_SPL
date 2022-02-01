//
//  ManagementViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import UIKit
import IAMPopup

// ViewModel - Model을 업데이트하고 그 결과를 다시 받아서 View에 전달하여 UI를 업데이트
class ManagementViewModel: NSObject {
    
    // MARK: - Properties
    
    let alertView = AlertView()
    var items = [ManagementViewModelItem]()
    
    var user: User
    var view: UIView
    var expand: Bool

    // MARK: - Lifecycle
    
    init(user: User, view: UIView, expand: Bool) {
        self.user = user
        self.view = view
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
    
    // MARK: - Action
    
    @objc func clickedCancel() {
        view.center_slideViewDown(height: 156)
    }
    
    // 회원 탈퇴
    @objc func clickeOk() {
        self.withdrawUser { error, statusCode in
            if let error = error {
                print(error); return
            }

            // FCM 토큰 갱신
            self.updateFCMtoken { error, statusCode in
                switch statusCode {
                case 200, 403:
                    print("\(statusCode ?? 0) 토큰 갱신 성공")
                    self.view.makeToast("새롭게 가입해보세요!", position: .center)
                    Helper.convertNavigationRootViewController(view: self.view, controller: VerificationViewController())
                default:
                    print("update token Error Code:", statusCode ?? 0)
                }
            }
        }
    }
    
    // MARK: - Helper
    
    func showAlertView() {
        alertView.titleLabel.text = "정말 탈퇴하시겠습니까?"
        alertView.subTitleLabel.text = "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ"
        
        alertView.cancelButton.addTarget(self, action: #selector(clickedCancel), for: .touchUpInside)
        alertView.okButton.addTarget(self, action: #selector(clickeOk), for: .touchUpInside)

        view.IAM_center(height: 156) { popupView in
            popupView.addSubview(self.alertView)
            self.alertView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func withdrawUser(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.withdrawSignUp(idToken: idToken) { error, statusCode in
            
            switch statusCode {
            case 200:
                UserDefaults.standard.set("withdrawUser", forKey: "startView")
            case 406:
                UserDefaults.standard.set("withdrawUser", forKey: "startView")
            default:
                print("withdrawUser - statusCode", statusCode ?? 0)
            }
            
            completion(error, statusCode)
        }
    }
    
    func updateFCMtoken(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        APIService.updateFCMtoken(idToken: idToken) { error, statusCode in
            completion(error, statusCode)
        }
    }
    
    func updateMyPage(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.updateMyPage(idToken: idToken) { error, statusCode in
            completion(error, statusCode)
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
            cell.selectionStyle = .none
            return cell

        case .hobby:
            let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .allow:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllowTableViewCell.identifier, for: indexPath) as! AllowTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .age:
            let cell = tableView.dequeueReusableCell(withIdentifier: AgeTableViewCell.identifier, for: indexPath) as! AgeTableViewCell
            cell.item = item
            cell.selectionStyle = .none
            return cell
            
        case .withdraw:
            let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawTabelViewCell.identifier, for: indexPath) as! WithdrawTabelViewCell
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
        } else if indexPath.section == 6 {
            self.showAlertView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 210 : (indexPath.section == 1 ? (expand ? UITableView.automaticDimension : 58) : 74)
    }
}
