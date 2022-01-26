//
//  AuthViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import FirebaseAuth
import Alamofire

class AuthViewModel {
        
    // MARK: - Request, Get Verification Code
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().languageCode = "ko"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                guard let error = error else {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    completion(verificationID, nil)
                    return
                }
                completion(nil, error)
            }
    }
    
    func getVerificationCode(verificationID: String?, verificationCode: String?, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "",
            verificationCode: verificationCode ?? ""
        )
        
        Auth.auth().signIn(with: credential) { success, error in
            if error == nil {
                print("Login Success!!!")

                Helper.getIDTokenRefresh {
                    completion(nil ,error); return
                } onSuccess: {
                    completion(success, nil)
                }

            } else {
                completion(nil, error)
                print("getVerificationCode Error: ",error.debugDescription)
            }
        }
    }
    
    // MARK: - API
    
    func getUserInfo(completion: @escaping (User?, Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        APIService.getUserInfo(idToken: idToken) { user, error, statusCode in
            
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")
            case 201:
                UserDefaults.standard.set("successLogin", forKey: "startView")
            default:
                print("getUserInfo - statusCode", statusCode ?? 0)
            }
            
            completion(user, error, statusCode)
        }
    }
    
    func signUpUserInfo(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.signUpUserInfo(idToken: idToken) { error, statusCode in
            
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")
            default:
                print("getUserInfo - statusCode", statusCode ?? 0)
            }
            
            completion(error, statusCode)
        }
    }
    
    func withdrawUser(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.withdrawSignUp(idToken: idToken) { error, statusCode in
            
            switch statusCode {
            case 200:
                UserDefaults.standard.set("withdrawUser", forKey: "startView")
            case 406:
                UserDefaults.standard.set("withdrawUser", forKey: "startView")
            default:
                print("withdrawUser - statusCode", statusCode ?? 0)
            }
            
            completion(error, statusCode)
        }
    }
    
    func updateFCMtoken(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        APIService.updateFCMtoken(idToken: idToken) { error, statusCode in
            completion(error, statusCode)
        }
    }
}
