//
//  ManagementItem.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import Foundation

// 각 Class에 대한 초기화값 제공

class BackgroundItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .background }
    
    var background: Int
    var sesac: Int
    
    init(background: Int, sesac: Int) {
        self.background = background
        self.sesac = sesac
    }
}

class TitleItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .title }
    
    var username: String
    var reputation: [Int]
    
    init(username: String, reputation: [Int]) {
        self.username = username
        self.reputation = reputation
    }
}

class GenderItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .gender }
    
    var gender: Int
    
    init(gender: Int) {
        self.gender = gender
    }
}

class HobbyItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .hobby }
    
    var hobby: String
    
    init(hobby: String) {
        self.hobby = hobby
    }
}

class AllowItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .allow }
    
    var searchable: Int
    
    init(searchable: Int) {
        self.searchable = searchable
    }
}

class AgeItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .age }
    
    var ageMin: Int
    var ageMax: Int
    
    init(ageMin: Int, ageMax: Int) {
        self.ageMin = ageMin
        self.ageMax = ageMax
    }
}

class WithdrawItem: ManagementViewModelItem {
    var type: ManagementViewModelItemType { return .withdraw }
}
