//
//  HomeViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation

class HomeViewModel {
    
    func searchFriend(region: Int, lat: Double, long: Double, completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let request = SearchFriendRequest(region: region, lat: lat, long: long)
        
        QueueAPI.searchFriend(idToken: idToken, request: request) { failed, statusCode in
            switch statusCode {
            case 200:
                print("취미 함께할 친구 검색 성공")
                completion(nil, statusCode)
            case 401:
                Helper.getIDTokenRefresh {
                    print("[signUpUserInfo] 토큰 갱신 실패", statusCode ?? 0)
                } onSuccess: { _ in
                    print("[signUpUserInfo] 토큰 갱신 성공", statusCode ?? 0)
                }
            default:
                print("searchFriend - statusCode", statusCode ?? 0)
                completion(failed, statusCode)
            }
        }
    }
    
    
    
}
