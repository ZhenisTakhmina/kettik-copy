//
//  KTEmailInputView.swift
//  Kettik
//
//  Created by Ruslan on 03.04.2024.
//

import UIKit

final class KTEmailInputView: KTInputView {
    
    init() {
        super.init(title: KTStrings.Common.email)
        
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        set(placeholder: KTStrings.Auth.enterYourEmail)
    }
}
