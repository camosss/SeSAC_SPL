//
//  SearchViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/13.
//

import Foundation

class SearchViewModel: NSObject {
    
    func stopFindFriend(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        QueueAPI.stopFindFriend(idToken: idToken) { failed, statusCode in
            switch statusCode {
            case 200:
                print("취미 함께할 친구 찾기 중단 성공")
                completion(nil, statusCode)
            case 201:
                print("취미 함께하기가 이미 매칭된 상태")
                completion(failed, statusCode)
            default:
                print("stopFindFriend", statusCode ?? 0)
                completion(failed, statusCode)
            }
        }
    }
}
