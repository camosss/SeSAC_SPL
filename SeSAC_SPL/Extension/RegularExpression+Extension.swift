//
//  RegularExpression+Extension.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import Foundation

extension String {
    func isValidPhoneNumber() -> Bool {
        let phoneNumRegex = "[0-1]{3}[-]+[0-9]{3,4}[-]+[0-9]{4}"
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneNumRegex)
        return pred.evaluate(with: self)
    }
    
    func isVaildVerificationCode() -> Bool {
        let codeRegex = "([0-9]{6})"
        let pred = NSPredicate(format:"SELF MATCHES %@", codeRegex)
        return pred.evaluate(with: self)
    }
    
    func isVaildEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return pred.evaluate(with: self)
    }
}
