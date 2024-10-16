//
//  JSONHelper.swift
//  Kettik
//
//  Created by Tami on 10.04.2022.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
