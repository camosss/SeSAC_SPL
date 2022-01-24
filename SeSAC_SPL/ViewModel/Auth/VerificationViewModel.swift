//
//  VerificationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation
import FirebaseAuth

class VerificationViewModel {
        
    // MARK: - Check Validation
    
    func isValidPhoneNumber(phone: String?) -> Bool {
        let phoneNumRegEx = "[0-1]{3}[-]+[0-9]{3,4}[-]+[0-9]{4}"
        let phoneNumTest = NSPredicate(format:"SELF MATCHES %@", phoneNumRegEx)
        return phoneNumTest.evaluate(with: phone)
    }
    
    func isVaildVerificationCode(code: String?) -> Bool {
        guard code != nil else { return false }
        
        let codeRegEx = "([0-9]{6})"
        let pred = NSPredicate(format:"SELF MATCHES %@", codeRegEx)
        return pred.evaluate(with: code)
    }
    
    // MARK: - Request, Get Verification Code
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().languageCode = "ko"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                guard let error = error else {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
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
                
                UserDefaults.standard.set(true, forKey: "VerificationCompleted")
                completion(success, nil)

            } else {
                completion(nil, error)
                print("getVerificationCode Error: ",error.debugDescription)
            }
        }
    }
}
