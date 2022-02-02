//
//  APIService.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import Moya

class AuthAPI {
    
    static private let service = MoyaProvider<AuthTarget>()
    
    static func getUser(idToken: String, completion: @escaping (_ succeed: User?, _ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.getUser(idToken: idToken)) { result in
            switch result {
            case .success(let response):
                completion(try? response.map(User.self), nil, response.statusCode)
                
            case .failure(let error):
                completion(nil, error, error.response?.statusCode)
            }
        }
    }
    
    static func signUpUser(idToken: String, request: SignUpRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.signUp(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                print("response", response.statusCode)
                completion(nil, response.statusCode)

            case .failure(let error):
                print("error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func withdrawSignUp(idToken: String, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.withdraw(idToken: idToken)) { result in
            print("result", result)
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)

            case .failure(let error):
                print("[withdrawSignUp] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func updateFCMtoken(idToken: String, request: FCMtokenRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.updateFCMtoken(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
                
            case .failure(let error):
                print("[updateFCMtoken] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
    
    static func updateMyPage(idToken: String, request: MypageRequest, completion: @escaping (_ failed: Error?, _ statusCode: Int?) -> Void) {
        
        service.request(.updateMypage(idToken: idToken, request)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
                
            case .failure(let error):
                print("[updateMyPage] response error", error)
                completion(error, error.response?.statusCode)
            }
        }
    }
}
