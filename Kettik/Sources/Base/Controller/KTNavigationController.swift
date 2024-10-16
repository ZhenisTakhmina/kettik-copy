//
//  KTNavigationController.swift
//  Kettik
//
//  Created by Tami on 04.03.2024.
//

import UIKit

class KTNavigationController: UINavigationController {
    
    static var defaultAppearance: UINavigationBarAppearance {
        let appearance: UINavigationBarAppearance = .init()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        return appearance
    }
    
    override var childForStatusBarStyle: UIViewController? {
        if let `presentedViewController` = presentedViewController {
            if presentedViewController.isBeingDismissed {
                return topViewController
            } else {
                return presentedViewController
            }
        } else {
            return topViewController
        }
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        commonInit()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    func commonInit() {
        view.backgroundColor = KTColors.Surface.primary.color
        view.isOpaque = true
        
        if #available(iOS 15.0, *) {
            navigationBar.standardAppearance = KTNavigationController.defaultAppearance
            navigationBar.scrollEdgeAppearance = KTNavigationController.defaultAppearance
        } else {
            navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    // MARK: - Неиспользуемые методы -
    @available(*, unavailable, message: "Unavailable")
    public required init?(coder aDecoder: NSCoder) { fatalError("Unavailable") }
}
