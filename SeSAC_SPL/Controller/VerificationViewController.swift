//
//  VerificationViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class VerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    
    let onboardingService = OnboardingService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !appDelegate.hasAlreadyLaunched {
            appDelegate.sethasAlreadyLaunched()
            displayOnboardingView()
        }
    }
    
    // MARK: - Helper
    
    func displayOnboardingView() {
        let onboardingVC = onboardingService.showOnboardingView()
        present(onboardingVC, animated: false)
    }
    
}
