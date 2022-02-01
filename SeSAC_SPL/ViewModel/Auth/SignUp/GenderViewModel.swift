//
//  GenderViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation
import Alamofire

class GenderViewModel {
    
    func signUpUserInfo(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.signUpUserInfo(idToken: idToken) { error, statusCode in
            
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
            
            completion(error, statusCode)
        }
    }
}
