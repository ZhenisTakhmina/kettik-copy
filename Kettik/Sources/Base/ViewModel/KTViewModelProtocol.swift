//
//  KTViewModelProtocol.swift
//  Kettik
//
//  Created by Tami on 05.05.2024.
//

import Foundation

protocol KTViewModelProtocol {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

