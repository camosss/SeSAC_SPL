//
//  SearchFriendRequest.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/04.
//

import Foundation

struct SearchFriendRequest: Encodable {
    let region: Int
    let lat: Double
    let long: Double
}
