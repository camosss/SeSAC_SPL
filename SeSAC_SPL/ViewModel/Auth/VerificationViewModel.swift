//
//  VerificationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import FirebaseAuth

class VerificationViewModel {
    
    var idToken = ""
//    var fcmToken = UserDefaults.standard.string(forKey: "FCMToken")!
    
    
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
                
//                let currentUser = Auth.auth().currentUser
//                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//
//                    if let error = error {
//                        completion(success ,error); return
//                    }
//
//                    if let idToken = idToken {
//                        print("idToken: ", idToken)
//                        self.idToken = idToken
//                        UserDefaults.standard.set(idToken, forKey: "idToken")
//                    }
//                    completion(success, nil)
//                }
                
                UserDefaults.standard.set(true, forKey: "verificationCompleted")
                completion(success, nil)

            } else {
                completion(nil, error)
                print("getVerificationCode Error: ",error.debugDescription)
            }
        }
    }
}
