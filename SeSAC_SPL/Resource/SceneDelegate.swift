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
        
        let idToken = UserDefaults.standard.string(forKey: "idToken") ?? ""
        print("SceneDelegate idToken", idToken)
        
        if idToken == "" { // 전화번호 인증 X
            convertRootViewController(VerificationViewController())
        } else { // 전화번호 인증 O
            APIService.getUserInfo(idToken: idToken) { user, error, statusCode in
                switch statusCode {
                case 200:
                    self.convertRootViewController(MyInfoViewController())
                default:
                    print(statusCode ?? 0)
                    self.convertRootViewController(NickNameViewController())
                }
            }
        }
    }
    
    func convertRootViewController(_ controller: UIViewController) {
        self.window?.rootViewController = UINavigationController(rootViewController: controller)
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

