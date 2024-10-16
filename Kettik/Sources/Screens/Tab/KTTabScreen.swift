//
//  KTTabScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit

final class KTTabScreen: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension KTTabScreen {
    
    func commonInit() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.shadowImage = KTImages.Tab.tabShadow.image
        
        tabBar.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        tabBar.isTranslucent = false
        tabBar.tintColor = KTColors.Brand.accent.color
        tabBar.unselectedItemTintColor = KTColors.Text.secondary.color
        
        viewControllers = [
            getTabController(for: KTExploreScreen(viewModel: .init(tripsCollectionsService: .init(), tripsService: .init())), title: KTStrings.Tab.explore, icon: KTImages.Tab.explore.image),
            getTabController(for: KTGuidesScreen(), title: KTStrings.Tab.guides, icon: KTImages.Tab.guides.image),
            getTabController(for: KTTicketsScreen(), title: KTStrings.Tab.orders, icon: KTImages.Tab.orders.image),
            getTabController(for: KTProfileScreen(), title: KTStrings.Tab.profile, icon: KTImages.Tab.profile.image)
        ]
    }
    
    func getTabController(for controller: UIViewController, title: String, icon: UIImage) -> UIViewController {
        let navigationController: KTNavigationController = .init(rootViewController: controller)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = icon
        return navigationController
    }
}
