//
//  Endpoint.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation

enum Endpoint {
    case user
    case user_withdraw
    case user_update_fcm_token
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user: return .makeEndpoint("user")
        case .user_withdraw: return .makeEndpoint("user/withdraw")
        case .user_update_fcm_token: return .makeEndpoint("user/update_fcm_token")
        }
    }
}

extension URL {
    static let baseURL = "http://test.monocoding.com:35484/"

    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}


