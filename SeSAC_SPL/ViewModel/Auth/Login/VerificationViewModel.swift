//
//  VerificationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import Alamofire

class VerificationViewModel: CommonViewModel {
    
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
    
    func phoneNumberTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isValidPhoneNumber() }
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
    
}
