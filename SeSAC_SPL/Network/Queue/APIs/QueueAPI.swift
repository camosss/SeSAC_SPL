//
//  QueueAPI.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/04.
//

import Foundation
import Moya

class QueueAPI {
    
    static private let service = MoyaProvider<QueueTarget>()

    static func findFriend(idToken: String, request: FindFriendRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.findFriend(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[findFriend] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func stopFindFriend(idToken: String, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.stopFindFriend(idToken: idToken)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[stopFindFriend] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func searchFriend(idToken: String, request: SearchFriendRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.searchFriend(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[searchFriend] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func hobbyShare(idToken: String, request: HobbyRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.hobbyShare(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[hobbyShare] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func hobbyAccept(idToken: String, request: HobbyRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.hobbyAccept(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[hobbyAccept] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func checkStatus(idToken: String, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.checkStatus(idToken: idToken)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[checkStatus] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }

}
