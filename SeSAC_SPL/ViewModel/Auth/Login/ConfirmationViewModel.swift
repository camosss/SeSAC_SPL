//
//  ConfirmationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class ConfirmationViewModel: CommonViewModel {
    
    var validText = BehaviorRelay<String>(value: "")

    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let validText: BehaviorRelay<String>
        let sceneTransition: ControlEvent<Void>
    }
    
    func certificationTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isVaildVerificationCode() }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
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
    
    func getUserInfo(completion: @escaping (User?, Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        UserAPI.getUser(idToken: idToken) { succeed, failed, statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")
                completion(succeed, nil, statusCode)

            case 201:
                UserDefaults.standard.set("successLogin", forKey: "startView")
                completion(succeed, nil, statusCode)

            case 401:
                Helper.getIDTokenRefresh {
                    print("[getUserInfo] - 토큰 갱신 실패", statusCode ?? 0)
                    completion(nil, failed, statusCode)

                } onSuccess: {
                    print("[getUserInfo] - 토큰 갱신 성공", statusCode ?? 0)
                    completion(succeed, nil, statusCode)

                }

            default:
                print("getUserInfo - statusCode", statusCode ?? 0)
                completion(nil, failed, statusCode)
            }
        }
    }
    
}
