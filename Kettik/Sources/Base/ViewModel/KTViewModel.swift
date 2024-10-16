//
//  KTViewModel.swift
//  Kettik
//
//  Created by Tami on 05.05.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class KTViewModel: NSObject {
    
    @Injected(\.dataService) var dataService: KTDataService
    
    let disposeBag: DisposeBag = .init()
    
    let defaultLoading: PublishRelay<Bool> = .init()
    let defaultPushViewController: PublishRelay<PushViewControllerConfiguration> = .init()
    let defaultPresentViewController: PublishRelay<PresentViewControllerConfiguration> = .init()
    let defaultPopViewController: PublishRelay<Void> = .init()
    let defaultDismissViewController: PublishRelay<DismissViewControllerConfiguration> = .init()
    
    deinit {
        #if DEBUG
            print("\(self) deinited.")
        #endif
    }
}

extension KTViewModel {
    
    func show(error: String?) {
        let text: String = error ?? "Please try again later..."
        Toast.text(
            .init(string: text, attributes: [
                .font: KTFonts.SFProText.medium.font(size: 12) as UIFont,
                .foregroundColor: KTColors.Text.primary.color as UIColor
            ]),
            viewConfig: .init(darkBackgroundColor: KTColors.Surface.primary.color, lightBackgroundColor: KTColors.Surface.primary.color, titleNumberOfLines: 0),
            config: .init(direction: .top, dismissBy: [.swipe(direction: .toTop), .tap, .time(time: 5)])
        ).show(haptic: .error)
    }
}

extension KTViewModel {
    
    struct PushViewControllerConfiguration {
        let controller: UIViewController
        let animated: Bool
    }
    
    struct PresentViewControllerConfiguration {
        let controller: UIViewController
        let animated: Bool
    }
    
    struct DismissViewControllerConfiguration {
        let animated: Bool
        let completion: (() -> Void)?
    }
}
