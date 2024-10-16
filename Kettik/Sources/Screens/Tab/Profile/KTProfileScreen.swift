//
//  KTProfileScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

// TODO: Рефакторинг
final class KTProfileScreen: KTScrollableViewController {
    
    override var prefersNavigationBarHidden: Bool {
        true
    }
    
    private let viewModel: KTProfileViewModel = .init()
    
    private let nameLabel: UILabel = .init().then {
        $0.textColor = KTColors.Text.primary.color
        $0.font = KTFonts.SFProText.bold.font(size: 22)
    }
    
    private let avatarView: UIImageView = .init().then {
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = KTColors.Surface.secondary.color
    }
    
    private let menuItemSelected: PublishRelay<KTProfileViewModel.MenuItem> = .init()
    
    override init() {
        super.init()
        modalPresentationStyle = .formSheet
    }
    
    override func setupViews() {
        super.setupViews()
        scrollView.snp.removeConstraints()
        
        let titleView: UIStackView = UIStackView(arrangedSubviews: [
            avatarView,
            nameLabel
        ]).then {
            $0.alignment = .center
            $0.spacing = 18
        }
        
        view.add(titleView) {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        contentView.add(
            UIStackView(arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    MenuButton(icon: KTImages.Tab.orders.image, title: KTStrings.Profile.myTickets, onTap: { [weak self] in
                        self?.menuItemSelected.accept(.myTickets)
                    }),
                    MenuButton(icon: KTImages.Tab.profile.image, title: KTStrings.Profile.myProfile, onTap: { [weak self] in
                        self?.menuItemSelected.accept(.myProfile)
                    }),
                    MenuButton(icon: KTImages.Profile.favorites.image, title: KTStrings.Profile.favourites, onTap: { [weak self] in
                        self?.menuItemSelected.accept(.favourites)
                    }),
                    MenuButton(icon: KTImages.Profile.language.image, title: KTStrings.Profile.language, onTap: { [weak self] in
                        self?.menuItemSelected.accept(.language)
                    }),
                    MenuButton(icon: KTImages.Profile.faq.image, title: KTStrings.Profile.faq, onTap: { [weak self] in
                        self?.menuItemSelected.accept(.faq)
                    })
                ]).then {
                    $0.axis = .vertical
                    $0.spacing = 16
                },
                UIStackView(arrangedSubviews: [
                    UILabel().then {
                        $0.text = KTStrings.Profile.socialMediaTitle
                        $0.font = KTFonts.SFProText.regular.font(size: 20)
                        $0.textColor = KTColors.Text.primary.color
                    },
                    
                    UIStackView(arrangedSubviews: [
                        KTImageButton(image: KTImages.Profile.instagram.image).then {
                            $0.rx.tap
                                .map { KTProfileViewModel.MenuItem.instagram }
                                .bind(to: menuItemSelected)
                                .disposed(by: disposeBag)
                        },
                        KTImageButton(image: KTImages.Profile.whatsApp.image).then {
                            $0.rx.tap
                                .map { KTProfileViewModel.MenuItem.whatsApp }
                                .bind(to: menuItemSelected)
                                .disposed(by: disposeBag)
                        },
                        KTImageButton(image: KTImages.Profile.telegram.image).then {
                            $0.rx.tap
                                .map { KTProfileViewModel.MenuItem.telegram }
                                .bind(to: menuItemSelected)
                                .disposed(by: disposeBag)
                        },
                    ]).then {
                        $0.spacing = 24
                        $0.alignment = .center
                    }
                ]).then {
                    $0.axis = .vertical
                    $0.alignment = .leading
                    $0.spacing = 24
                },
                
                MenuButton(icon: KTImages.Profile.signOut.image, title: KTStrings.Profile.signOut, onTap: { [weak self] in
                    self?.menuItemSelected.accept(.signOut)
                })
            ]).then {
                $0.axis = .vertical
                $0.spacing = 44
            },
        {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 24, vertical: 44))
        })
        
        avatarView.snp.makeConstraints {
            $0.size.equalTo(48)
        }
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTProfileViewModel.Input = .init(
            viewWillAppear: rx.viewWillAppear.mapToVoid(), 
            menuItemSelected: menuItemSelected.asObservable()
        )
        let output: KTProfileViewModel.Output = viewModel.transform(input: input)
        
        output.name
            .drive(onNext: { [unowned self] name in
                nameLabel.text = name
            })
            .disposed(by: disposeBag)
    }
}

private extension KTProfileScreen {
    
}

fileprivate final class MenuButton: KTButton {
    
    private let disposeBag: DisposeBag = .init()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.24) {
                if self.isHighlighted {
                    self.alpha = 0.4
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                } else {
                    self.alpha = 1
                    self.transform = .identity
                }
            }
        }
    }
    
    init(icon: UIImage, title: String, onTap: @escaping (() -> Void)) {
        super.init()
        let stackView: UIStackView = .init(arrangedSubviews: [
            UIImageView(image: icon).then {
                $0.contentMode = .scaleAspectFit
                $0.snp.makeConstraints { m in m.size.equalTo(32) }
            },
            UILabel().then {
                $0.text = title
                $0.font = KTFonts.SFProText.medium.font(size: 16)
                $0.textColor = KTColors.Text.primary.color
            }
        ]).then {
            $0.alignment = .center
            $0.spacing = 20
            $0.isUserInteractionEnabled = false
        }
        
        add(stackView, {
            $0.edges.equalToSuperview()
        })
        
        rx.tap.mapToVoid()
            .bind(onNext: onTap)
            .disposed(by: disposeBag)
    }
}


