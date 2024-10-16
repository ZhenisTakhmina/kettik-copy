//
//  KTSignUpViewModel.swift
//  Kettik
//
//  Created by Tami on 24.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

final class KTSignUpViewModel: KTViewModel {
    
    @Injected(\.applicationService) private var applicationService: KTApplicationService
    @Injected(\.authorizationService) private var authorizationService: KTAuthorizationService
    
    private let observableFullName: BehaviorRelay<String?> = .init(value: nil)
    private let observableEmail: BehaviorRelay<String?> = .init(value: nil)
    private let observablePassword: BehaviorRelay<String?> = .init(value: nil)
}

private extension KTSignUpViewModel {
    
    func signUp() {
        guard
            let name = observableFullName.value,
            let email = observableEmail.value,
            let password = observablePassword.value
        else {
            return
        }
        
        defaultLoading.accept(true)
        authorizationService.rxSignUp(email: email, password: password)
            .subscribe(onSuccess: { [weak self] userId in
                self?.createProfile(userId: userId, fullName: name)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                switch (error as NSError).code {
                case 17026: self.show(error: "Weak password.")
                case 17007: self.show(error: "Email is already in use.")
                case 17008: self.show(error: "Invalid email.")
                default: self.show(error: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createProfile(
        userId: String,
        fullName: String
    ) {
        authorizationService.rxCreateProfile(
            id: userId,
            data: [
                "full_name": fullName
            ]
        )
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.applicationService.handleSuccessAuthorization()
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension KTSignUpViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let fullName: Observable<String?>
        let email: Observable<String?>
        let password: Observable<String?>
        let signUp: Observable<Void>
    }
    
    struct Output {
        
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        input.fullName
            .bind(to: observableFullName)
            .disposed(by: disposeBag)
        
        input.password
            .bind(to: observablePassword)
            .disposed(by: disposeBag)
        
        input.email
            .bind(to: observableEmail)
            .disposed(by: disposeBag)
        
        input.signUp
            .bind(onNext: { [unowned self] in
                signUp()
            })
            .disposed(by: disposeBag)
        
        return .init(
        
        )
    }
}
