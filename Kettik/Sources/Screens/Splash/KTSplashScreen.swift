//
//  KTSplashScreen.swift
//  Kettik
//
//  Created by Tami on 17.03.2024.
//

import UIKit
import SwiftUI
import Then

final class KTSplashScreen: KTViewController {
    
    @Injected(\.applicationService) private var applicationService: KTApplicationService
    @Injected(\.authorizationService) private var authorizationService: KTAuthorizationService
    @Injected(\.dataService) private var dataService: KTDataService
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = KTColors.Brand.accent.color
        setupLogo()
    }
}

private extension KTSplashScreen {
    
    func loadData() {
        let loadables: [KTSplashLoadable] = [
            dataService,
            authorizationService
        ]
        
        let dispatchGroup: DispatchGroup = .init()
        
        loadables.forEach { loadable in
            dispatchGroup.enter()
            
            loadable.loadInitialData {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.applicationService.handleSplashCompletion()
        }
    }
}

private extension KTSplashScreen {
    
    func setupLogo() {
        
        let iconView: UIImageView = .init(image: KTImages.Brand.splashLogo.image).then {
            $0.contentMode = .scaleAspectFit
        }
        
        view.add(iconView) {
            $0.center.equalToSuperview()
        }
        view.add(KTSpinnerView(color: .white, backgroundColor: .white.withAlphaComponent(0.2))) {
            $0.size.equalTo(44)
            $0.top.equalTo(iconView.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
        }
    }
}


