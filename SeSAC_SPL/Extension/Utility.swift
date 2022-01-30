//
//  Utility.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/20.
//

import UIKit
import RxSwift

class Utility {
    
    // MARK: - TextField
    
    static func inputContainerView(textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(8)
            make.trailing.equalTo(view.snp.trailing).inset(8)
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = R.color.gray3()
        
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(0.75)
        }
        
        return view
    }
    
    static func birthTextField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.textAlignment = .center
        tf.isEnabled = false
        tf.font = R.font.notoSansKRRegular(size: 14)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return tf
    }
    
    // MARK: - Label
    
    static func label(text: String, textColor: UIColor!) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    static func birthLabel(text: String, textColor: UIColor!) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        label.font = R.font.notoSansKRRegular(size: 16)
        return label
    }
    
    static func managementLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = R.color.black()
        label.font = R.font.notoSansKRRegular(size: 14)
        return label
    }
    
    // MARK: - Button
    
    static func button(setTitleColor: UIColor!, backgroundColor: UIColor!) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(setTitleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.cornerRadius = 8
        button.titleLabel?.font = R.font.notoSansKRRegular(size: 14)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }
    
    static func genderButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(R.color.black(), for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = R.font.notoSansKRRegular(size: 14)
        button.clipsToBounds = true
        button.cornerRadius = 8
        button.layer.borderColor = R.color.gray3()?.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    // MARK: - StackView
    
    static func stackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution, arrangedSubviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        return stack
    }
    
    static func dateStackView(_ arrangedSubviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        return stack
    }
    
    // MARK: - Slider
    
    static func sliderView() -> UISlider {
        let slider = UISlider()
        slider.minimumTrackTintColor = R.color.green()
        slider.maximumTrackTintColor = R.color.gray2()
        slider.thumbTintColor = R.color.green()
        slider.maximumValue = 65
        slider.minimumValue = 18
        return slider
    }
}
