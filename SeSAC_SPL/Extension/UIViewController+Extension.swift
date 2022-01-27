//
//  UIViewController+Extension.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/27.
//

import UIKit
import Network
import Toast_Swift

extension UIViewController {
    
    func networkMoniter() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.view.makeToast("네트워크 연결이 원활하지 않습니다.", position: .center)
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}
