//
//  Helper.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/25.
//

import Foundation
import RxSwift
import Toast_Swift
import FirebaseAuth

class Helper {
    static func makeRequestPhoneNumber(_ number: String) -> String {
        if number != "" {
            let phoneNumber = number.replacingOccurrences(of: "-", with: "")
            let startIdx = phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)
            let result = String(phoneNumber[startIdx...])
            return "+\(82)\(result)"
        } else {
            return "error"
        }
    }
    
    static func switchButton(_ clicked: UIButton, _ unclicked: UIButton) {
        clicked.backgroundColor = R.color.whitegreen()
        unclicked.backgroundColor = R.color.white()
    }
    
    static func switchInfoButton(_ clicked: UIButton, _ unclicked: UIButton) {
        clicked.setTitleColor(R.color.white(), for: .normal)
        clicked.backgroundColor = R.color.green()
        
        unclicked.setTitleColor(R.color.black(), for: .normal)
        unclicked.backgroundColor = R.color.white()
    }
    
    static func switchFilterButton(_ clicked: UIButton, _ unclicked1: UIButton, _ unclicked2: UIButton) {
        clicked.setTitleColor(R.color.white(), for: .normal)
        clicked.backgroundColor = R.color.green()
        
        unclicked1.setTitleColor(R.color.black(), for: .normal)
        unclicked1.backgroundColor = R.color.white()
        unclicked2.setTitleColor(R.color.black(), for: .normal)
        unclicked2.backgroundColor = R.color.white()
    }
    
    static func templateNavigationController(image: UIImage, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
    
    static func getIDTokenRefresh(onError: @escaping () -> (), onSuccess: @escaping (String) -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in

            if let _ = error {
                onError(); return
            }

            if let idToken = idToken {
                print("갱신 idToken: ", idToken)
                UserDefaults.standard.set(idToken, forKey: "idToken")
                onSuccess(idToken)
            }
        }
    }
    
    static func convertNavigationRootViewController(view: UIView, controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let nav = UINavigationController(rootViewController: controller)
            view.window?.rootViewController = nav
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            view.window?.makeKeyAndVisible()
        }
    }
    
    static func convertRootViewController(view: UIView, controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.window?.rootViewController = controller
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            view.window?.makeKeyAndVisible()
        }
    }
    
    static func convertRegion(lat: Double, long: Double) -> Int {
        let numberFomatter = NumberFormatter()
        numberFomatter.roundingMode = .floor
        numberFomatter.maximumSignificantDigits = 5
        
        let latitude = numberFomatter.string(for: lat + 90) ?? ""
        let longitude = numberFomatter.string(for: long + 180) ?? ""
        
        let region = Int("\(latitude)\(longitude)".components(separatedBy: ["."]).joined()) ?? 0
        return region
    }
}
