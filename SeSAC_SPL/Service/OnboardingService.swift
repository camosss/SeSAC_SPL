//
//  OnboardingService.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class OnboardingService {
    func showOnboardingView() -> OnboardingViewController {
        let sb = UIStoryboard(name: "Onboarding", bundle: .main)
        let onboardingVC = sb.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingVC.modalPresentationStyle = .fullScreen
        return onboardingVC
    }
}
