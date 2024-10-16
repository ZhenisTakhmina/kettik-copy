//
//  JSONHelper.swift
//  Kettik
//
//  Created by Tami on 10.04.2022.
//

import Foundation

extension InjectedValues {
    
    var applicationService: KTApplicationService {
        get { Self[ApplicationServiceKey.self] }
        set { Self[ApplicationServiceKey.self] = newValue }
    }
    
    private struct ApplicationServiceKey: InjectionKey {
        static var currentValue: KTApplicationService = .init()
    }
}

extension InjectedValues {
    
    var authorizationService: KTAuthorizationService {
        get { Self[AuthorizationServiceKey.self] }
        set { Self[AuthorizationServiceKey.self] = newValue }
    }
    
    private struct AuthorizationServiceKey: InjectionKey {
        static var currentValue: KTAuthorizationService = .init()
    }
}


extension InjectedValues {
    
    var dataService: KTDataService {
        get { Self[DataServiceKey.self] }
        set { Self[DataServiceKey.self] = newValue }
    }
    
    private struct DataServiceKey: InjectionKey {
        static var currentValue: KTDataService = .init()
    }
}


