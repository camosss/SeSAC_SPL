//
//  Date+Extension.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import Foundation

extension Date {
    func toString(dateValue: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.string(from: dateValue)
    }
    
    func toBirthString(dateValue: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: dateValue)
    }
}
