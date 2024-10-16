//
//  KTStatic.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation
import UIKit

enum KTStatic {
    
    enum SocialMediaLink {
        
        static let instagram: URL = .init(string: "https://www.instagram.com").unsafelyUnwrapped
        static let whatsapp: URL = .init(string: "https://www.whatsapp.com").unsafelyUnwrapped
        static let telegram: URL = .init(string: "https://telegram.org").unsafelyUnwrapped
    }
    
    enum ApplicationLink {
        
        static let settings: URL = .init(string: UIApplication.openSettingsURLString).unsafelyUnwrapped
    }
}
