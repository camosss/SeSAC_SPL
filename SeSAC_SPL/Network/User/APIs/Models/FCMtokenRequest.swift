//
//  FCMtokenRequest.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/02.
//

import Foundation

struct FCMtokenRequest: Encodable {
    var FCMtoken: String
}

extension FCMtokenRequest {
    var toDomain: FCMtokenRequest {
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        return FCMtokenRequest(FCMtoken: FCMtoken)
    }
}
