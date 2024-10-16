//
//  KTTicketScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI

final class KTTicketScreen: KTViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private let ticket: KTTicketAdapter
    
    private let qrView: UIImageView = .init(image: KTImages.Mock.qr.image).then {
        $0.contentMode = .scaleAspectFit
    }
    private let ticketView: UIImageView = .init(image: KTImages.Element.fullTicket.image).then {
        $0.contentMode = .scaleToFill
        $0.alpha = 0
        $0.transform = .init(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: 1000)
    }
    
    private let backButton: KTImageButton = .init(image: KTImages.Control.backNavBar.image)
    
    private let titleView: KTTicketKeyValueView = .init(title: KTStrings.Ticket.trip)
    private let priceView: KTTicketKeyValueView = .init(title: KTStrings.Ticket.price)
    private let countView: KTTicketKeyValueView = .init(title: KTStrings.Ticket.count)
    private let dateView: KTTicketKeyValueView = .init(title: KTStrings.Ticket.date)
    private let statusView: KTTicketKeyValueView = .init(title: KTStrings.Ticket.status)
    
    init(ticket: KTTicketAdapter) {
        self.ticket = ticket
        super.init()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
        
        titleView.set(value: ticket.name)
        priceView.set(value: ticket.formattedTotalPrice)
        countView.set(value: "\(ticket.count)")
        dateView.set(value: "\(ticket.purchaseDate)")
        updateTicketStatusUI(status: TicketStatus(rawValue: ticket.status) ?? .pending)
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = KTColors.Brand.accent.color
        
        let logoView: UIImageView = .init(image: KTImages.Brand.splashLogo.image).then {
            $0.contentMode = .scaleAspectFit
        }
        
        view.add(logoView, {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.size.equalTo(64)
        })
        
        view.add(ticketView, {
            $0.center.equalToSuperview()
        })
        
        view.add(backButton, {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.equalToSuperview().offset(24)
        })
        
        let infoStackView: UIStackView = .init(arrangedSubviews: [
            statusView,
            titleView,
            priceView,
            countView,
            dateView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 18
        }
        
        ticketView.add(qrView, {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(44)
            $0.size.equalTo(200)
        })
        
        ticketView.add(infoStackView) {
            $0.top.equalToSuperview().offset(324)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func bind() {
        super.bind()
        backButton.rx.tap.mapToVoid()
            .bind(onNext: { [unowned self] in
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .take(1)
            .mapToVoid()
            .bind(onNext: { [unowned self] in
                animateTicket()
            })
            .disposed(by: disposeBag)
    }
}

private extension KTTicketScreen {
    
    func animateTicket() {
        UIView.animate(withDuration: 0.5, animations: {
            self.ticketView.alpha = 1
            self.ticketView.transform = .identity
        })
    }
    
    func updateTicketStatusUI(status: TicketStatus){
        statusView.set(value: status.info.statusText)
        statusView.valueLabel.textColor = status.info.textColor
        qrView.image = status.info.image
    }
}

