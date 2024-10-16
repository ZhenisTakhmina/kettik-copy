//
//  KTProfileViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

final class KTProfileViewModel: KTViewModel {
    
    @Injected(\.applicationService) private var applicationService: KTApplicationService
    @Injected(\.authorizationService) private var authorizationService: KTAuthorizationService
}

private extension KTProfileViewModel {
    
    func handle(menuItem: MenuItem) {
        switch menuItem {
        case .myTickets:
            defaultPushViewController.accept(.init(controller: KTTicketsScreen(), animated: true))
        case .myProfile:
            defaultPushViewController.accept(.init(controller: KTPRofileSettingsScreen(), animated: true))
        case .favourites:
            defaultPushViewController.accept(.init(controller: KTFavouritesScreen(), animated: true))
        case .language:
            open(url: KTStatic.ApplicationLink.settings)
        case .faq:
            defaultPushViewController.accept(.init(controller: KTFAQScreen(), animated: true))
        case .signOut:
            signOut()
        case .instagram:
            open(url: KTStatic.SocialMediaLink.instagram, inApp: false)
        case .whatsApp:
            open(url: KTStatic.SocialMediaLink.whatsapp)
        case .telegram:
            open(url: KTStatic.SocialMediaLink.telegram)
        }
    }
}
private extension KTProfileViewModel {
    
    func signOut() {
        defaultLoading.accept(true)
        authorizationService.rxSignOut()
            .subscribe(onSuccess: { [weak self] in
                guard let self = self else { return }
                self.applicationService.handleSignOut()
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func open(url: URL, inApp: Bool = false) {
        if inApp {
            let screen: SFSafariViewController = .init(url: url)
            defaultPresentViewController.accept(.init(controller: screen, animated: true))
        } else {
            guard UIApplication.shared.canOpenURL(url) else {
                show(error: "Failed to open link.")
                return
            }
            
            UIApplication.shared.open(url)
        }
    }
}

extension KTProfileViewModel {
    
    enum MenuItem {
        
        case myTickets
        case myProfile
        case favourites
        case language
        case faq
        case signOut
        case instagram
        case whatsApp
        case telegram
    }
}

extension KTProfileViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let viewWillAppear: Observable<Void>
        let menuItemSelected: Observable<MenuItem>
    }
    
    struct Output {
        
        let name: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        let name: Driver<String?> = Observable.merge(
            .just(authorizationService.currentUserProfile?.fullName),
            input.viewWillAppear.map { [weak self] in self?.authorizationService.currentUserProfile?.fullName }
        ).asDriverOnErrorJustComplete()
        input.menuItemSelected
            .bind(onNext: { [unowned self] item in
                handle(menuItem: item)
            })
            .disposed(by: disposeBag)
        
        return .init(
            name: name
        )
    }
}
