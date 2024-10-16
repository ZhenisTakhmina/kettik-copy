//
//  KTPasswordInputView.swift
//  Kettik
//
//  Created by Ruslan on 03.04.2024.
//

import UIKit

final class KTPasswordInputView: KTInputView {
    
    init() {
        super.init(title: KTStrings.Common.password)
        
        textField.keyboardType = .asciiCapable
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        textField.isSecureTextEntry = true
        
        set(placeholder: KTStrings.Auth.enterPassword)
    }
}
