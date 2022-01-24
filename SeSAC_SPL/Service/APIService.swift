//
//  APIService.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import Alamofire

class APIService {
    
    static func getUserInfo(idToken: String, completion: @escaping (User?, AFError?, Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "idtoken": "\(idToken)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        AF.request(Endpoint.user.url.absoluteString, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode

            switch response.result {
            case.success(let value):
                print("[getUserInfo] response success", value)
                completion(value, nil, statusCode)

            case .failure(let error):
                print("[getUserInfo] response error",error.localizedDescription)
                completion(nil, error, statusCode)
            }
        }
    }
    
    static func signUpUserInfo(idToken: String, completion: @escaping (String?, AFError?, Int?) -> Void) {
        
        let headers = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ] as HTTPHeaders
        
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nick = UserDefaults.standard.string(forKey: "nickName") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        let parameters : Parameters = [
            "phoneNumber" : phoneNumber,
            "FCMtoken" : FCMtoken,
            "nick" : nick,
            "birth" : birth,
            "email" : email,
            "gender" : gender
        ]
        
        AF.request(Endpoint.user.url.absoluteString, method: .post, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print("[signUpUserInfo] response success", value)
                completion(value, nil, statusCode)
                
            case .failure(let error):
                print("[signUpUserInfo] response error", error)
                completion(nil, error, statusCode)
            }
        }
    }
    
    static func withdrawSignUp(idToken: String, completion: @escaping (Int?, Error?) -> Void){
        let headers = [
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ] as HTTPHeaders
        
        AF.request(Endpoint.user_withdraw.url.absoluteString, method: .post, headers: headers).responseString { response in
            completion(response.response?.statusCode, nil)
        }
    }
    
}
