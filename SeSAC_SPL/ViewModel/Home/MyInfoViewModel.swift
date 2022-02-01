//
//  MyInfoViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import Foundation
import RxCocoa
import Alamofire

class MyInfoViewModel: NSObject {

    lazy var myinfos = BehaviorRelay<[MyInfo]>(value: [
        MyInfo(image: R.image.profileImg()!, item: ""),
        MyInfo(image: R.image.notice()!, item: "공지사항"),
        MyInfo(image: R.image.qna()!, item: "자주 묻는 질문"),
        MyInfo(image: R.image.faq()!, item: "1:1 문의"),
        MyInfo(image: R.image.settingAlarm()!, item: "알림 설정"),
        MyInfo(image: R.image.permit()!, item: "이용 약관")
    ])
    
    func getUserInfo(completion: @escaping (User?, Error?, Int?) -> Void) {
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""

        APIService.getUserInfo(idToken: idToken) { user, error, statusCode in
            
            switch statusCode {
            case 200:
                UserDefaults.standard.set("alreadySignUp", forKey: "startView")
                
            case 201:
                UserDefaults.standard.set("successLogin", forKey: "startView")
                
            case 401:
                Helper.getIDTokenRefresh {
                    print("[getUserInfo] - 토큰 갱신 실패", statusCode ?? 0)
                } onSuccess: {
                    print("[getUserInfo] - 토큰 갱신 성공", statusCode ?? 0)
                }

            default:
                print("getUserInfo - statusCode", statusCode ?? 0)
            }
            
            completion(user, error, statusCode)
        }
    }
}
