//
//  JSONHelper.swift
//  Kettik
//
//  Created by Tami on 10.04.2022.
//

import Foundation

public protocol InjectionKey {

    associatedtype Value

    static var currentValue: Self.Value { get set }
}
