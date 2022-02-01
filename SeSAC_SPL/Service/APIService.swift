//
//  APIService.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import Alamofire

class APIService {
    
    static func getUserInfo(idToken: String, completion: @escaping (User?, Error?, Int?) -> Void) {

        let headers: HTTPHeaders = [
            "idtoken": idToken
        ]

        AF.request(Endpoint.user.url.absoluteString, method: .get, headers: headers).responseDecodable(of: User.self) { response in

            let statusCode = response.response?.statusCode

            switch response.result {
            case.success(let value):
                completion(value, nil, statusCode)

            case .failure(let error):
                print("[getUserInfo] response error",error.localizedDescription)
                completion(nil, error, statusCode)
            }
        }
    }
    
    static func signUpUserInfo(idToken: String, completion: @escaping (Error?, Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nick = UserDefaults.standard.string(forKey: "nickName") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        let parameters : Parameters = [
            "phoneNumber": phoneNumber,
            "FCMtoken": FCMtoken,
            "nick": nick,
            "birth": birth,
            "email": email,
            "gender": gender
        ]
        
        AF.request(Endpoint.user.url.absoluteString, method: .post, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print("[signUpUserInfo] response success", value)
                completion(nil, statusCode)
                
            case .failure(let error):
                print("[signUpUserInfo] response error", error)
                completion(error, statusCode)
            }
        }
    }
    
    static func withdrawSignUp(idToken: String, completion: @escaping (Error?, Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        AF.request(Endpoint.user_withdraw.url.absoluteString, method: .post, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode

            switch response.result {
            case .success(let value):
                print("[withdrawSignUp] response success", value)
                completion(nil, statusCode)
                
            case .failure(let error):
                print("[withdrawSignUp] response error", error)
                completion(error, statusCode)
            }
        }
    }
    
    static func updateFCMtoken(idToken: String, completion: @escaping (Error?, Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        let parameters : Parameters = [
            "FCMtoken": FCMtoken
        ]
        
        AF.request(Endpoint.user_update_fcm_token.url.absoluteString, method: .put, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print("[updateFCMtoken] response success", value)
                completion(nil, statusCode)
                
            case .failure(let error):
                print("[updateFCMtoken] response error", error)
                completion(error, statusCode)
            }
        }
    }
    
    static func updateMyPage(idToken: String, completion: @escaping (Error?, Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let searchable = UserDefaults.standard.integer(forKey: "searchable")
        let ageMin = UserDefaults.standard.integer(forKey: "ageMin")
        let ageMax = UserDefaults.standard.integer(forKey: "ageMax")
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let hobby = UserDefaults.standard.string(forKey: "hobby") ?? ""

        let parameters : Parameters = [
            "searchable": searchable,
            "ageMin": ageMin,
            "ageMax": ageMax,
            "gender": gender,
            "hobby": hobby
        ]
        
        AF.request(Endpoint.user_update_mypage.url, method: .post, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print("[updateMyPage] response success", value)
                completion(nil, statusCode)
                
            case .failure(let error):
                print("[updateMyPage] response error", error)
                completion(error, statusCode)
            }
        }
    }
}
