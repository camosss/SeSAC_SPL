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
    
    static func handleButtonEvent(authView: AuthView, output: ValidationViewModel.Output, disposeBag: DisposeBag, sceneTransition: @escaping () -> ()) {

        output.validStatus
            .map { $0 ? R.color.green() : R.color.gray6() }
            .bind(to: authView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.validStatus
            .bind(to: authView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.validText
            .asDriver()
            .drive(authView.inputTextField.rx.text)
            .disposed(by: disposeBag)

        output.sceneTransition
            .subscribe { _ in
                sceneTransition()
            }.disposed(by: disposeBag)
    }
    
    static func templateNavigationController(image: UIImage, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
    
    static func getIDTokenRefresh(onError: @escaping () -> (), onSuccess: @escaping () -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in

            if let _ = error {
                onError(); return
            }

            if let idToken = idToken {
                print("idToken: ", idToken)
                UserDefaults.standard.set(idToken, forKey: "idToken")
                onSuccess()
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
    
}
