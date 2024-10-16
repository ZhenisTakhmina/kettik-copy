//
//  KTPRofileSettingsScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI

final class KTPRofileSettingsScreen: KTScrollableViewController {
    
    private let viewModel: KTPRofileSettingsViewModel = .init()
    
    private let fullNameView: KTInputView = .init(title: KTStrings.Common.fullName)
    private let saveButton: KTPrimaryButton = .init(title: KTStrings.Profile.save)
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Profile.myProfile
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            fullNameView,
            saveButton
        ]).then {
            $0.axis = .vertical
            $0.setCustomSpacing(24, after: fullNameView)
        }
        
        contentView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 24, vertical: 24))
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTPRofileSettingsViewModel.Input = .init(
            fullName: fullNameView.textField.rx.text.asObservable(),
            save: saveButton.rx.tap.mapToVoid()
        )
        let output: KTPRofileSettingsViewModel.Output = viewModel.transform(input: input)
        
        output.fullName
            .drive(onNext: { [unowned self] name in
                fullNameView.textField.text = name
            })
            .disposed(by: disposeBag)
    }
}

