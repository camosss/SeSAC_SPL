//
//  BirthViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

class BirthViewController: UIViewController {
    
    // MARK: - Properties
        
    let birthView = BirthView()
    let viewModel = ValidationViewModel()
    let disposeBag = DisposeBag()
    let datePicker = UIDatePicker()
    
    var birthDateString = ""

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBirthView()
        configureDatePicker()
        handleDatePicker()
    }
    
    // MARK: - Action
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        handleNextButton()
        birthDateString = (sender.date).toBirthString(dateValue: sender.date)
        
        let dateString = sender.date.toString(dateValue: sender.date)
        let dateArray = dateString.split(separator: " ").map{ String($0) }
        
        birthView.yearTextField.text = dateArray[0]
        birthView.monthTextField.text = dateArray[1]
        birthView.dayTextField.text = dateArray[2]
    }
    
    // MARK: - Helper
    
    func configureBirthView() {
        birthView.delegate = self
        birthView.nextButton.setTitle("다음", for: .normal)
        birthView.nextButton.isEnabled = false
    }
    
    func configureDatePicker() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func handleNextButton() {
        birthView.nextButton.isEnabled = true
        birthView.nextButton.backgroundColor = R.color.green()
    }
    
    func handleDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame.size = CGSize(width: 0, height: 200)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
}

// MARK: - AuthViewDelegate

extension BirthViewController: BirthViewDelegate {
    func handleNextButtonAction() {
        UserDefaults.standard.set(birthDateString, forKey: "birth")

        let controller = EmailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
