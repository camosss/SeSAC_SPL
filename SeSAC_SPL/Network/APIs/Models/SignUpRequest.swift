//
//  SignUpRequest.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/02.
//

import Foundation

struct SignUpRequest: Encodable {
    let phoneNumber: String
    var FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    var gender: Int
}

extension SignUpRequest {
    var toDomain: SignUpRequest {
        let FCMtoken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        let nick = UserDefaults.standard.string(forKey: "nickName") ?? ""
        let birth = UserDefaults.standard.string(forKey: "birth") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        return SignUpRequest(phoneNumber: phoneNumber,
                             FCMtoken: FCMtoken,
                             nick: nick,
                             birth: birth,
                             email: email,
                             gender: gender)
    }
    
}
