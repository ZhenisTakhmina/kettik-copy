//
//  KTLibsProvider.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore

enum KTLibsProvider {
    
    @MainActor static func configure() {
        
        configureFirebase()
        configureIQKeyboardManager()
    }
}

private extension KTLibsProvider {
    
    @MainActor static func configureIQKeyboardManager() {
        
        IQKeyboardManager.shared.enable = true
    }
    
    @MainActor static func configureFirebase() {
        
        FirebaseApp.configure()
    }
}
