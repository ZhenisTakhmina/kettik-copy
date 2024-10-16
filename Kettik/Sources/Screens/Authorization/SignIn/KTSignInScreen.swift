//
//  KTSignInScreen.swift
//  Kettik
//
//  Created by Tami on 24.02.2024.
//

import UIKit
import SwiftUI
import IQKeyboardManagerSwift
import GoogleSignIn
import FirebaseAuth

final class KTSignInScreen: KTViewController {
    
    override var navigationBarStyle: KTViewController.NavigationBarStyle {
        .transparent(configuration: .init())
    }
    private let viewModel: KTSignInViewModel = .init()
    
    private let emailView: KTEmailInputView = .init()
    private let passwordView: KTPasswordInputView = .init()
    
    private let loginButton: KTPrimaryButton = .init(title: KTStrings.Auth.logIn)
    
    private let googleButton: KTGoogleButton = .init(title: "  Continue with Google")
    
    private let resetButton: UIButton = .init(type: .system).then {
        $0.setTitle(KTStrings.Auth.fogotPassword, for: .normal)
        $0.tintColor = KTColors.Text.primary.color
        $0.titleLabel?.font = KTFonts.SFProText.regular.font(size: 13)
    }
    
    private let signUpButton: UIButton = .init(type: .system).then {
        $0.setTitle(KTStrings.Auth.signUp, for: .normal)
        $0.tintColor = KTColors.Brand.accent.color
        $0.titleLabel?.font = KTFonts.SFProText.bold.font(size: 14)
    }
    
    override func setupViews() {
        super.setupViews()
        let stackView: UIStackView = .init(arrangedSubviews: [
            UILabel().then {
                $0.text = KTStrings.Auth.title
                $0.font = KTFonts.SFProText.bold.font(size: 32)
                $0.textColor = KTColors.Brand.accent.color
                $0.adjustsFontSizeToFitWidth = true
            },
            
            UIStackView(arrangedSubviews: [
                IQPreviousNextView().then { view in
                    let stackView: UIStackView = .init(arrangedSubviews: [
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
                UIStackView(arrangedSubviews: [
                    UIView(),
                    resetButton
                ])
            ]).then {
                $0.axis = .vertical
                $0.spacing = 12
            },
            
            loginButton,
            googleButton,
            
            UIStackView(arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    UILabel().then {
                        $0.text = KTStrings.Auth.signUpText
                        $0.font = KTFonts.SFProText.regular.font(size: 14)
                        $0.textColor = KTColors.Text.primary.color
                    },
                    signUpButton
                ]).then {
                    $0.alignment = .center
                    $0.spacing = 4
                }
            ]).then {
                $0.alignment = .center
                $0.axis = .vertical
            }
        ]).then {
            $0.axis = .vertical
            $0.spacing = 44
            $0.setCustomSpacing(24, after: loginButton)
        }
        
        view.add(stackView, {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(18)
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTSignInViewModel.Input = .init(
            email: emailView.textField.rx.text.asObservable(),
            password: passwordView.textField.rx.text.asObservable(),
            signIn: loginButton.rx.tap.mapToVoid(),
            signUp: signUpButton.rx.tap.mapToVoid(),
            googleSignIn: googleButton.rx.tap.mapToVoid()
        )
        viewModel.transform(input: input)
    }
}


