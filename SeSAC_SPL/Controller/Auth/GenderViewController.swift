//
//  GenderViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit

class GenderViewController: UIViewController {
    
    // MARK: - Properties
    
    let authView = AuthView()
    
    let manButton: GenderButton = {
        let button = GenderButton()
        button.genderImageView.image = UIImage(systemName: "person.fill")
        button.genderLabel.text = "남자"
        button.addTarget(self, action: #selector(manButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let womanButton: GenderButton = {
        let button = GenderButton()
        button.genderImageView.image = UIImage(systemName: "person")
        button.genderLabel.text = "여자"
        button.addTarget(self, action: #selector(womanButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var genderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [manButton, womanButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureAuthView()
        configureGenderView()
    }
    
    // MARK: - Action
    
    @objc func manButtonClicked() {
        print("man")
    }
    
    @objc func womanButtonClicked() {
        print("woman")
    }
    
    // MARK: - Helper
    
    func configureAuthView() {
        authView.delegate = self
        authView.inputContainerView.isHidden = true
        
        authView.titleLabel.text = "성별을 선택해주세요"
        authView.subTitleLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        authView.nextButton.setTitle("다음", for: .normal)
    }
    
    func configureGenderView() {
        authView.addSubview(genderStack)
        genderStack.snp.makeConstraints { make in
            make.top.equalTo(authView.subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - AuthViewDelegate
extension GenderViewController: AuthViewDelegate {
    func handleNextButtonAction() {
        let controller = MyInfoViewController()
        
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
}
