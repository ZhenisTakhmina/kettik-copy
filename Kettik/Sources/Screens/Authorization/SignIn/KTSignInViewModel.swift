//
//  KTSignInViewModel.swift
//  Kettik
//
//  Created by Tami on 24.02.2024.
//

import Foundation
import RxCocoa
import RxSwift
import Toast
import FirebaseAuth
import UIKit
import GoogleSignIn

final class KTSignInViewModel: KTViewModel {
    
    @Injected(\.applicationService) private var applicationService: KTApplicationService
    @Injected(\.authorizationService) private var authorizationService: KTAuthorizationService
 
    private let observableEmail: BehaviorRelay<String?> = .init(value: nil)
    private let observablePassword: BehaviorRelay<String?> = .init(value: nil)
}

 extension KTSignInViewModel {
    
    func signInWithGoogle() {
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        authorizationService.rxConfigureGoogleSignIn(from: presentingVC)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] userID in
                self?.getProfile(userId: userID)
            },onFailure: { [weak self] error in
                guard let self = self else { return }
                self.show(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func signIn() {
        guard 
            let email = observableEmail.value,
            let password = observablePassword.value,
            !email.isEmpty,
            !password.isEmpty
        else {
            show(error: "Invalid credentials.")
            return
        }
        defaultLoading.accept(true)
        
        authorizationService.rxSignIn(email: email, password: password)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] userId in
                self?.getProfile(userId: userId)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                switch (error as NSError).code {
                case 17008: self.show(error: "Invalid email.")
                case 17004: self.show(error: "Invalid credentials.")
                default: self.show(error: nil)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func getProfile(userId: String) {
        authorizationService.rxGetProfile(userId: userId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] user in
                self?.applicationService.handleSuccessAuthorization()
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension KTSignInViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let email: Observable<String?>
        let password: Observable<String?>
        let signIn: Observable<Void>
        let signUp: Observable<Void>
        let googleSignIn: Observable<Void>
    }
    
    struct Output {
        
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        input.email
            .bind(to: observableEmail)
            .disposed(by: disposeBag)
        
        input.password
            .bind(to: observablePassword)
            .disposed(by: disposeBag)
        
        input.signIn
            .bind(onNext: { [unowned self] in
                signIn()
            })
            .disposed(by: disposeBag)
        
        input.signUp
            .map { KTSignUpScreen() }
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        input.googleSignIn
            .bind(onNext: { [unowned self] in
                signInWithGoogle()
            })
            .disposed(by: disposeBag)
        
        return .init()
    }
}
