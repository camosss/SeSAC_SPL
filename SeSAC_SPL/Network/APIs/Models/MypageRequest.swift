//
//  MypageRequest.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/02.
//

import Foundation

struct MypageRequest {
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var hobby: String
}

extension MypageRequest {
    var toDomain: MypageRequest {
        let searchable = UserDefaults.standard.integer(forKey: "searchable")
        let ageMin = UserDefaults.standard.integer(forKey: "ageMin")
        let ageMax = UserDefaults.standard.integer(forKey: "ageMax")
        let gender = UserDefaults.standard.integer(forKey: "gender")
        let hobby = UserDefaults.standard.string(forKey: "hobby") ?? ""
        
        return MypageRequest(searchable: searchable,
                             ageMin: ageMin,
                             ageMax: ageMax,
                             gender: gender,
                             hobby: hobby)
    }
}
