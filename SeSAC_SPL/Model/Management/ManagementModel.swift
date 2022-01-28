//
//  ManagementModelItem.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/28.
//

import Foundation

// MARK: - Type
// 각 case는 각각의 TableViewCell이 필요한 데이터 형식을 나타낸다

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
// 동일한 TableView 내에서 데이터를 사용하기 때문에, 모든 속성을 결정하는 단일 DataModelItem 생성

protocol ManagementViewModelItem {
    var type: ManagementViewModelItemType { get }
    var rowCount: Int { get }
}

extension ManagementViewModelItem {
    var rowCount: Int { return 1 } // 1로 고정
}
