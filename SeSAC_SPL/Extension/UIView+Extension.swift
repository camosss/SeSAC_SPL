//
//  UIView+Extension.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/19.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}
