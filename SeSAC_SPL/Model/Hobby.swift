//
//  Hobby.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/10.
//

import Foundation

struct Hobby {
    let name: String
    let type: HobbyModelType
}

enum HobbyModelType {
    case recommend
    case hf
}
