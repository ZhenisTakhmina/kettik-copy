//
//  KTBaseScreen.swift
//  Kettik
//
//  Created by Tami on 26.02.2024.
//

import UIKit
import RxSwift
import KMNavigationBarTransition

class KTViewController: UIViewController {
    
    let disposeBag: DisposeBag = .init()
    
    var prefersNavigationBarHidden: Bool {
        false
    }
    
    private(set) lazy var loadingView: KTFullScreenLoadingView = .init()
    
    var navigationBarStyle: NavigationBarStyle {
        .default(configuration: .init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if prefersNavigationBarHidden {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        } else {
            navigationController?.setNavigationBarHidden(false, animated: animated)
            applyNavigationBarStyle()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    func setupViews() {
        view.backgroundColor = KTColors.Surface.primary.color
    }
    
    func bind() {
        
    }
    
    func set(loading: Bool) {
        if loading {
            guard loadingView.superview == nil else { return }
            
            view.addSubview(loadingView)
        } else {
            loadingView.removeFromSuperview()
        }
    }
    
    deinit {
        #if DEBUG
            print("\(self) deinited.")
        #endif
    }
    
    @available(*, unavailable, message: "Unavailable")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError("Unavailable") }
    
    @available(*, unavailable, message: "Unavailable")
    public required init?(coder aDecoder: NSCoder) { fatalError("Unavailable") }
}

extension KTViewController {
    
    func bindDefaultTriggers(forViewModel viewModel: KTViewModel) {
        viewModel.defaultLoading
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] loading in
                self?.set(loading: loading)
            })
            .disposed(by: disposeBag)
        
        viewModel.defaultPushViewController
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] configuration in
                self?.handle(pushViewControllerConfiguration: configuration)
            })
            .disposed(by: disposeBag)
        
        viewModel.defaultPresentViewController
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] configuration in
                guard let self = self else { return }
                self.present(configuration.controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.defaultPopViewController
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.defaultDismissViewController
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] configuration in
                self?.dismiss(animated: configuration.animated, completion: configuration.completion)
            })
            .disposed(by: disposeBag)
    }
    
    func handle(pushViewControllerConfiguration configuration: KTViewModel.PushViewControllerConfiguration) {
        navigationController?.pushViewController(configuration.controller, animated: configuration.animated)
    }
}

private extension KTViewController {
    
    func commonInit() {
        navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    func applyNavigationBarStyle() {
        guard let navigationController = navigationController else { return }
        
        let applyShadowStyleForced: ((_ navigationController: UINavigationController) -> Void) = { navigationController in
            navigationController.navigationBar.standardAppearance.shadowColor = UIColor.clear
            navigationController.navigationBar.standardAppearance.shadowImage = UIImage()
            
            navigationController.navigationBar.scrollEdgeAppearance?.shadowColor = UIColor.clear
            navigationController.navigationBar.scrollEdgeAppearance?.shadowImage = UIImage()
        }
        
        switch navigationBarStyle {
        case .default(let configuration):
            navigationController.navigationBar.isTranslucent = false
            
            let navigationBarAppearance: UINavigationBarAppearance = KTNavigationController.defaultAppearance
            
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = configuration.barTintColor
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: configuration.titleTextColor as UIColor,
                .font: KTFonts.SFProText.medium.font(size: 18) as UIFont
            ]

            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            
            navigationController.navigationBar.tintColor = configuration.tintColor

        case .transparent(let configuration):
            navigationController.navigationBar.isTranslucent = true
            
            let navigationBarAppearance: UINavigationBarAppearance = KTNavigationController.defaultAppearance
            
            navigationBarAppearance.configureWithTransparentBackground()
            navigationBarAppearance.backgroundColor = .clear
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: configuration.titleTextColor as UIColor,
                .font: KTFonts.SFProText.medium.font(size: 18) as UIFont
            ]

            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationController.navigationBar.standardAppearance = navigationBarAppearance

            navigationController.navigationBar.tintColor = configuration.tintColor
        }
        
        applyShadowStyleForced(navigationController)
        
        km_addTransitionNavigationBarIfNeeded()
    }
}

extension KTViewController {
    
    enum NavigationBarStyle {
        case `default`(configuration: NavigationBarDefaultConfiguration)
        case transparent(configuration: NavigationBarTransparentConfiguration)
    }
    
    struct NavigationBarDefaultConfiguration {
        var barTintColor: UIColor = KTColors.Surface.primary.color
        var tintColor: UIColor = KTColors.Brand.accent.color
        var titleTextColor: UIColor = KTColors.Text.primary.color
    }

    struct NavigationBarTransparentConfiguration {
        var tintColor: UIColor = KTColors.Text.primary.color
        var titleTextColor: UIColor = KTColors.Text.primary.color
    }
}

extension KTViewController: UIGestureRecognizerDelegate {}
