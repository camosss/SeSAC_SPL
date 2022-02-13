//
//  InputHobbyViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/07.
//

import Foundation

class InputHobbyViewModel {
    
    var aroundItems = [Hobby]()
    var wantItems = [String]()
    
    func getUserInfo(completion: @escaping (User?, Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        UserAPI.getUser(idToken: idToken) { succeed, failed, statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")
                completion(succeed, nil, statusCode)

            case 406:
                UserDefaults.standard.set("successLogin", forKey: "startView")
                completion(succeed, nil, statusCode)

            case 401:
                Helper.getIDTokenRefresh {
                    print("[getUserInfo] - 토큰 갱신 실패", statusCode ?? 0)
                    completion(nil, failed, statusCode)
                } onSuccess: { idtoken in
                    print("[getUserInfo] - 토큰 갱신 성공", statusCode ?? 0)
                    
                    UserAPI.getUser(idToken: idtoken) { succeed, failed, statusCode in
                        completion(succeed, nil, statusCode)
                    }
                }

            default:
                print("getUserInfo - statusCode", statusCode ?? 0)
                completion(nil, failed, statusCode)
            }
        }
    }
    
    func findFriend(type: Int, region: Int, lat: Double, long: Double, hf: Array<String>, completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let request = FindFriendRequest(type: type, region: region, lat: lat, long: long, hf: hf)
        
        QueueAPI.findFriend(idToken: idToken, request: request) { failed, statusCode in
            switch statusCode {
            case 200:
                print("새싹 찾기 화면(1_3_near_user & 1_4_accept)으로 전환")
                UserDefaults.standard.set(2, forKey: "floatingButton")
                completion(nil, statusCode)
            case 201:
                print("“신고가 누적되어 이용하실 수 없습니다” 토스트 메시지")
                completion(failed, statusCode)
            case 204:
                print("“약속 취소 패널티로, 1분동안 이용하실 수 없습니다” 토스트 메시지를 띄우고 취미 입력 화면을 그대로 유지")
                completion(failed, statusCode)
            case 205:
                print("“연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다” 토스트 메시지를 띄우고 취미 입력 화면을 그대로 유지")
                completion(failed, statusCode)
            case 206:
                print("“새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!”라는 토스트 메시지를 띄우고, 정보 관리 화면(4_1_my_info)으로 전환")
                completion(failed, statusCode)
            default:
                print("findFriend", statusCode ?? 0)
                completion(failed, statusCode)
            }
        }
        
    }

    func searchFriend(region: Int, lat: Double, long: Double, completion: @escaping (SearchFriendResponse? ,Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let request = SearchFriendRequest(region: region, lat: lat, long: long)
        
        QueueAPI.searchFriend(idToken: idToken, request: request) { succeed, failed, statusCode in
            switch statusCode {
            case 200:
                print("취미 함께할 친구 검색 성공")
                
                let recommend = succeed?.fromRecommend.map{ Hobby(name: $0, type: .recommend) } ?? []
                var hf = succeed?.fromQueueDB.map{ $0.hf }.flatMap{$0}.map{ Hobby(name: $0, type: .hf) } ?? []
                
                // hf 안의 중복 제거해야함
                
                // "지금 주변에는", "내가 하고 싶은" 중복 제거
                recommend.forEach { recommendValue in
                    hf.forEach { hfValue in
                        if recommendValue.name == hfValue.name {
                            hf.removeAll(where: {$0.name == hfValue.name})
                        }
                    }
                }
                
                self.aroundItems = recommend + hf
                self.aroundItems.removeAll(where: { $0.name == "anything" })
                
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
