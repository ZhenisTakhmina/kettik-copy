//
//  KTSplashLoadable.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import Foundation

protocol KTSplashLoadable {
    
    typealias Completion = (() -> Void)
    
    func loadInitialData(_ completion: @escaping Completion)
}
