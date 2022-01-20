//
//  BirthViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class BirthViewController: UIViewController {
    
    // MARK: - Properties
    
    let birthView = BirthView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        birthView.delegate = self
    }
}

// MARK: - AuthViewDelegate

extension BirthViewController: BirthViewDelegate {
    func handleNextButtonAction() {
        let controller = EmailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
