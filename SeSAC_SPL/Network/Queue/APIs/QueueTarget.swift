//
//  QueueTarget.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/04.
//

import Moya

enum QueueTarget {
    case findFriend(idToken: String, FindFriendRequest)
    case stopFindFriend(idToken: String)
    case searchFriend(idToken: String, SearchFriendRequest)
    case hobbyShare(idToken: String, HobbyRequest)
    case hobbyAccept(idToken: String, HobbyRequest)
    case checkStatus(idToken: String)
}

extension QueueTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484/")!
    }
    
    var path: String {
        switch self {
        case .findFriend: return "queue"
        case .stopFindFriend: return "queue"
        case .searchFriend: return "queue/onqueue"
        case .hobbyShare: return "queue/hobbyrequest"
        case .hobbyAccept: return "queue/hobbyaccept"
        case .checkStatus: return "queue/myQueueState"
        }
    }
    
    var method: Method {
        switch self {
        case .findFriend: return .post
        case .stopFindFriend: return .delete
        case .searchFriend: return .post
        case .hobbyShare: return .post
        case .hobbyAccept: return .post
        case .checkStatus: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .findFriend(_, let request):
            return .requestParameters(parameters: [
                "type": request.type,
                "region": request.region,
                "lat": request.lat,
                "long": request.long,
                "hf": request.hf
            ], encoding: URLEncoding(arrayEncoding: .noBrackets))
            
        case .stopFindFriend:
            return .requestPlain

        case .searchFriend(_, let request):
            return .requestParameters(parameters: [
                "region": request.region,
                "lat": request.lat,
                "long": request.long
            ], encoding: URLEncoding.default)
            
        case .hobbyShare(_, let request):
            return .requestParameters(parameters: [
                "otheruid": request.otheruid
            ], encoding: URLEncoding.default)
            
        case .hobbyAccept(_, let request):
            return .requestParameters(parameters: [
                "otheruid": request.otheruid
            ], encoding: URLEncoding.default)
            
        case .checkStatus:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .findFriend(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .stopFindFriend(let idToken):
            return [
                "idtoken": idToken
            ]
        case .searchFriend(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .hobbyShare(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .hobbyAccept(let idToken, _):
            return [
                "idtoken": idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .checkStatus(let idToken):
            return [
                "idtoken": idToken
            ]
        }
    }
}
