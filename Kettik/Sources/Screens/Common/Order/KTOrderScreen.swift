//
//  KTOrderScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI

final class KTOrderScreen: KTViewController {
    
    private let viewModel: KTOrderViewModel
    
    private let progressView: ProgressView = .init()
    
    private let titleLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 24)
        $0.numberOfLines = 0
        $0.textColor = KTColors.Text.primary.color
    }
    private let nameTextView: KTInputView = .init(title: "Name")
    private let phoneNumber: KTInputView = .init(title: "Phone number")
    private let countControl: KTCountControl = .init()
    private let totalPriceLabel: UILabel = .init().then {
        $0.textColor = KTColors.Text.primary.color
        $0.font = KTFonts.SFProText.heavy.font(size: 32)
    }
    private let purchaseButton: KTPrimaryButton = .init(title: KTStrings.Ticket.makePurchase)
    
    init(viewModel: KTOrderViewModel) {
        self.viewModel = viewModel
        super.init()
        modalPresentationStyle = .formSheet
    }
    
    override func set(loading: Bool) {
        if loading {
            isModalInPresentation = true
            progressView.show()
            countControl.isEnabled = false
            purchaseButton.isEnabled = false
        } else {
            isModalInPresentation = false
            progressView.hide()
            countControl.isEnabled = true
            purchaseButton.isEnabled = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        view.isOpaque = true
        view.backgroundColor = .clear
        
        let containerView: KTView = .init(backgroundColor: KTColors.Surface.primary.color)
        let containerStackView: UIStackView = getContainerStackView()
        
        let headerView: UIImageView = .init(image: KTImages.Element.tripDetailsHeader.image).then {
            $0.contentMode = .scaleToFill
        }
        
        view.add(containerView, {
            $0.trailing.bottom.leading.equalToSuperview()
        })
        view.add(headerView, {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        })
        view.add(progressView) {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        }
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(containerView)
        
        containerView.add(containerStackView, {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).inset(24)
            $0.leading.equalToSuperview().offset(24)
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTOrderViewModel.Input = .init(
            name: nameTextView.textField.rx.text.orEmpty.asObservable(),
            phoneNumber: phoneNumber.textField.rx.text.orEmpty.asObservable(),
            decCount: countControl.decButton.rx.tap.mapToVoid(),
            incCount: countControl.incButton.rx.tap.mapToVoid(),
            order: purchaseButton.rx.tap.mapToVoid()
        )
        let output: KTOrderViewModel.Output = viewModel.transform(input: input)
        
        output.totalCount
            .drive(onNext: { [unowned self] count in
                countControl.set(count: count)
            })
            .disposed(by: disposeBag)
        
        output.totalPrice
            .drive(onNext: { [unowned self] price in
                totalPriceLabel.text = price.kztFormatted
            })
            .disposed(by: disposeBag)
        
        output.trip
            .drive(onNext: { [unowned self] trip in
                titleLabel.text = trip.name?[KTTripAdapter.shared]
            })
            .disposed(by: disposeBag)
        
        output.showPending
            .drive(onNext: {[weak self] in
                self?.progressView.showPending()
            })
            .disposed(by: disposeBag)
        
         }
    }


private extension KTOrderScreen {
    
    func getContainerStackView() -> UIStackView {
        .init(arrangedSubviews: [
            titleLabel,
            nameTextView,
            phoneNumber,
            countControl,
            UIStackView(arrangedSubviews: [
                UILabel().then {
                    $0.text = KTStrings.Trip.totalPrice
                    $0.font = KTFonts.SFProText.bold.font(size: 14)
                    $0.textColor = KTColors.Text.secondary.color
                },
                totalPriceLabel
            ]).then {
                $0.axis = .vertical
                $0.alignment = .center
                $0.spacing = 2
                $0.setCustomSpacing(10, after: phoneNumber)
            },
            purchaseButton
        ]).then {
            $0.axis = .vertical
            $0.spacing = 18
            $0.setCustomSpacing(44, after: titleLabel)
            $0.setCustomSpacing(32, after: countControl)
        }
    }
}

fileprivate final class ProgressView: KTView {
    
    private let spinnerView: KTSpinnerView = .init(color: .white, backgroundColor: .white.withAlphaComponent(0.5))
    
    private let headerView: UIImageView = .init(image: KTImages.Element.tripDetailsHeader.image.withRenderingMode(.alwaysTemplate)).then {
        $0.contentMode = .scaleToFill
        $0.tintColor = KTColors.Brand.accent.color
    }
    
    private let contentView: KTView = .init(backgroundColor: KTColors.Brand.accent.color)
    
    private let pendingLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.heavy.font(size: 32)
        $0.textColor = .white
        $0.text = KTStrings.Ticket.pending
        $0.alpha = 0
        $0.transform = .init(translationX: 0, y: 100)
    }
    
    override func setupViews() {
        super.setupViews()
        isHidden = true
        transform = .init(translationX: 0, y: 100)
        
        add(contentView, {
            $0.trailing.bottom.leading.equalToSuperview()
            $0.height.equalTo(100)
        })
        add(headerView, {
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.top)
        })
        add(spinnerView, {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.size.equalTo(56)
        })
        add(pendingLabel, {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
        })
    }
    
    func showPending() {
        UIView.animate(withDuration: 0.24, animations: {
            self.spinnerView.transform = .init(scaleX: 0.2, y: 0.2)
            self.spinnerView.alpha = 0
            self.headerView.tintColor = KTColors.Status.pending.color
            self.contentView.layer.backgroundColor = KTColors.Status.pending.color.cgColor
            self.pendingLabel.transform = .identity
            self.pendingLabel.alpha = 1
        })
    }
    
    func show() {
        isHidden = false
        UIView.animate(withDuration: 0.24, animations: {
            self.transform = .identity
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.24, animations: {
            self.transform = .init(translationX: 0, y: 100)
        }, completion: { [weak self] _ in
            self?.isHidden = true
        })
    }
}


