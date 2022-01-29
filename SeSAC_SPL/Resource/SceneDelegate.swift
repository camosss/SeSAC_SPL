//
//  SceneDelegate.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/19.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let startView = UserDefaults.standard.string(forKey: "startView")
        print("------> startView = \(startView ?? "전화번호인증 하러가야함")")
        
        if startView == "successLogin" {
            convertNavRootViewController(NickNameViewController())
        } else if startView == "alreadySignUp" {
            convertRootViewController(MainTapController())
        } else {
            convertNavRootViewController(VerificationViewController())
        }
        
    }
    
    func convertRootViewController(_ controller: UIViewController) {
        self.window?.rootViewController = controller
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        window?.makeKeyAndVisible()
    }
    
    func convertNavRootViewController(_ controller: UIViewController) {
        let nav = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = nav
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}

