//
//  UITextField.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import UIKit

extension UITextField {
    func defineAsDatePicker<T>(target: T, valueChangedAction: Selector) {
        let birthDatePicker = UIDatePicker()
        birthDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            birthDatePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = birthDatePicker
        birthDatePicker.addTarget(target, action: valueChangedAction, for: .valueChanged)
    }
}
