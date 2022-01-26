//
//  Helper.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/25.
//

import Foundation
import RxSwift
import Toast_Swift

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
        unclicked.layer.borderColor = R.color.gray3()?.cgColor
        unclicked.layer.borderWidth = 1
    }
    
    // MARK: - Button Event
    
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
    
    // MARK: - UITabBarController
    
    static func templateNavigationController(image: UIImage, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
}
