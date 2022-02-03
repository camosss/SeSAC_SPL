//
//  UserTarget.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/02.
//

import Moya

enum UserTarget {
    case getUser(idToken: String)
    case signUp(idToken: String, SignUpRequest)
    case withdraw(idToken: String)
    case updateFCMtoken(idToken: String, FCMtokenRequest)
    case updateMypage(idToken: String, MypageRequest)
}

extension UserTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484/")!
    }
    
    var path: String {
        switch self {
        case .getUser: return "user"
        case .signUp: return "user"
        case .withdraw: return "user/withdraw"
        case .updateFCMtoken: return "user/update_fcm_token"
        case .updateMypage: return "user/update/mypage"
        }
    }
    
    var method: Method {
        switch self {
        case .getUser: return .get
        case .signUp: return .post
        case .withdraw: return .post
        case .updateFCMtoken: return .put
        case .updateMypage: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
            
        case .signUp(_, let request):
            return .requestParameters(parameters: [
                "phoneNumber": request.phoneNumber,
                "FCMtoken": request.FCMtoken,
                "nick": request.nick,
                "birth": request.birth,
                "email": request.email,
                "gender": request.gender
            ], encoding: URLEncoding.default)
            
        case .withdraw:
            return .requestPlain
            
        case .updateFCMtoken(_, let request):
            return .requestParameters(parameters: [
                "FCMtoken": request.FCMtoken
            ], encoding: URLEncoding.default)
            
        case .updateMypage(_, let request):
            return .requestParameters(parameters: [
                "searchable": request.searchable,
                "ageMin": request.ageMin,
                "ageMax": request.ageMax,
                "gender": request.gender,
                "hobby": request.hobby
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUser(let idToken):
            return [
                "idtoken": idToken
            ]
        case .signUp(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .withdraw(let idToken):
            return [
                "idtoken": idToken
            ]
        case .updateFCMtoken(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .updateMypage(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
}
