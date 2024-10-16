//
//  KTPRofileSettingsViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

final class KTPRofileSettingsViewModel: KTViewModel {
    
    @Injected(\.authorizationService) var authorizationService: KTAuthorizationService
    private let usersService: KTUsersService = .init()
    
    private lazy var observableFullName: BehaviorRelay<String?> = .init(value: authorizationService.currentUserProfile?.fullName)
}

private extension KTPRofileSettingsViewModel {
    
    func save() {
        guard let fullName = observableFullName.value, !fullName.isEmpty else {
            show(error: "Invalid name.")
            return
        }
        
        if fullName == authorizationService.currentUserProfile?.fullName {
            defaultPopViewController.accept(())
            return
        }
        
        defaultLoading.accept(true)
        usersService.rxUpdateProfile(fullName: fullName)
            .subscribe(onSuccess: { [weak self] in
                guard let self = self else { return }
                self.defaultPopViewController.accept(())
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.show(error: nil)
                self.defaultLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}

extension KTPRofileSettingsViewModel: KTViewModelProtocol {
    
    struct Input {
        let fullName: Observable<String?>
        let save: Observable<Void>
    }
    
    struct Output {
        let fullName: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        input.fullName
            .bind(to: observableFullName)
            .disposed(by: disposeBag)
        
        input.save
            .bind(onNext: { [unowned self] in
                save()
            })
            .disposed(by: disposeBag)
        
        return .init(
            fullName: .just(authorizationService.currentUserProfile?.fullName)
        )
    }
}
