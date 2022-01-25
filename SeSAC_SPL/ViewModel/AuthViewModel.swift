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
                
                self.getIDTokenRefresh {
                    completion(success ,error); return
                } onSuccess: {
                    completion(success, nil)
                }

            } else {
                completion(nil, error)
                print("getVerificationCode Error: ",error.debugDescription)
            }
        }
    }
    
    func getIDTokenRefresh(onError: @escaping () -> (), onSuccess: @escaping () -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in

            if let _ = error {
                onError(); return
            }

            if let idToken = idToken {
                print("idToken: ", idToken)
                UserDefaults.standard.set(idToken, forKey: "idToken")
                onSuccess()
            }
        }
    }
    
    func convertRootViewController(view: UIView, controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let nav = UINavigationController(rootViewController: controller)
            view.window?.rootViewController = nav
            view.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - API
    
    func getMyUserInfo(completion: @escaping (User?, Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.getUserInfo(idToken: idToken) { user, error, statusCode in
            print("statusCode:", statusCode ?? 0)
            if let user = user {
                completion(user, nil, statusCode)
            } else {
                completion(nil, error, statusCode)
            }
        }
    }
    
    
    func signUpMyUserInfo(completion: @escaping (Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        
        APIService.signUpUserInfo(idToken: idToken) { _, error, statusCode in
            completion(error, statusCode)
        }
    }
}
