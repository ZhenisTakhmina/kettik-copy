//
//  KTSignUpScreen.swift
//  Kettik
//
//  Created by Tami on 24.02.2024.
//

import UIKit
import SwiftUI
import IQKeyboardManagerSwift

final class KTSignUpScreen: KTViewController {
    
    override var navigationBarStyle: KTViewController.NavigationBarStyle {
        .transparent(configuration: .init(tintColor: KTColors.Brand.accent.color))
    }
    
    private let viewModel: KTSignUpViewModel = .init()
    
    private let emailView: KTEmailInputView = .init()
    private let nameView: KTInputView = .init(title: KTStrings.Common.fullName).then {
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .words
        $0.set(placeholder: KTStrings.Auth.enterFullName)
    }
    private let passwordView: KTPasswordInputView = .init()
    
    private let signUpButton: KTPrimaryButton = .init(title: KTStrings.Auth.signUp)
    
    private let resetButton: UIButton = .init(type: .system).then {
        $0.setTitle(KTStrings.Auth.fogotPassword, for: .normal)
        $0.tintColor = KTColors.Text.primary.color
        $0.titleLabel?.font = KTFonts.SFProText.regular.font(size: 13)
    }
    
    override func setupViews() {
        super.setupViews()
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            UILabel().then {
                $0.text = KTStrings.Auth.signUp
                $0.font = KTFonts.SFProText.bold.font(size: 32)
                $0.textColor = KTColors.Brand.accent.color
                $0.adjustsFontSizeToFitWidth = true
            },
            
            UIStackView(arrangedSubviews: [
                IQPreviousNextView().then { view in
                    let stackView: UIStackView = .init(arrangedSubviews: [
                        nameView,
                        emailView,
                        passwordView
                    ]).then {
                        $0.axis = .vertical
                        $0.spacing = 12
                    }
                    view.add(stackView, {
                        $0.edges.equalToSuperview()
                    })
                },
                
                UILabel().then {
                    $0.text = KTStrings.Auth.passwordHint
                    $0.font = KTFonts.SFProText.regular.font(size: 12)
                    $0.textColor = KTColors.Text.secondary.color
                    $0.numberOfLines = 0
                }
            ]).then {
                $0.axis = .vertical
                $0.spacing = 12
            },
            
            signUpButton,
        ]).then {
            $0.axis = .vertical
            $0.spacing = 44
        }
        
        view.add(stackView, {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(18)
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTSignUpViewModel.Input = .init(
            fullName: nameView.textField.rx.text.asObservable(),
            email: emailView.textField.rx.text.asObservable(),
            password: passwordView.textField.rx.text.asObservable(),
            signUp: signUpButton.rx.tap.mapToVoid()
        )
        viewModel.transform(input: input)
    }
}

