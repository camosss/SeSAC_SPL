//
//  SearchViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import Foundation

class SearchViewModel {
    
    var aroundItems = [Hobby]()
    var wantItems: [String] = ["넷플릭스", "풋살"]

    func searchFriend(region: Int, lat: Double, long: Double, completion: @escaping (SearchFriendResponse? ,Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let request = SearchFriendRequest(region: region, lat: lat, long: long)
        
        QueueAPI.searchFriend(idToken: idToken, request: request) { succeed, failed, statusCode in
            switch statusCode {
            case 200:
                print("취미 함께할 친구 검색 성공")
                
                let recommend = succeed?.fromRecommend.map{ Hobby(name: $0, type: .recommend) } ?? []
                let hf = succeed?.fromQueueDB.map{$0.hf}.flatMap{$0}.map{Hobby(name: $0, type: .hf)} ?? []
                self.aroundItems = recommend + hf
                
                completion(succeed, nil, statusCode)
            case 401:
                Helper.getIDTokenRefresh {
                    print("[signUpUserInfo] 토큰 갱신 실패", statusCode ?? 0)
                } onSuccess: { _ in
                    print("[signUpUserInfo] 토큰 갱신 성공", statusCode ?? 0)
                }
            default:
                print("searchFriend - statusCode", statusCode ?? 0)
                completion(nil, failed, statusCode)
            }
        }
    }
}
