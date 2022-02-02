//
//  GenderViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation

class GenderViewModel {
    
    func signUpUserInfo(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        let request = SignUpRequest(phoneNumber: "", FCMtoken: "", nick: "", birth: "", email: "", gender: 0).toDomain

        UserAPI.signUpUser(idToken: idToken, request: request) { failed, statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")

            case 401:
                Helper.getIDTokenRefresh {
                    print("[signUpUserInfo] 토큰 갱신 실패", statusCode ?? 0)
                } onSuccess: {
                    print("[signUpUserInfo] 토큰 갱신 성공", statusCode ?? 0)
                }
            default:
                print("signUpUserInfo - statusCode", statusCode ?? 0)
            }
            completion(failed, statusCode)
        }
    }
}
