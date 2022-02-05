//
//  SearchFriendResponse.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/05.
//

import Foundation

struct SearchFriendResponse: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}
