//
//  KTTripDetailsFooterView.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit

final class KTTripDetailsFooterView: KTView {
    
    let bookButton: KTPrimaryButton = .init(title: KTStrings.Trip.bookNow)
    private let priceLabel: UILabel = .init().then {
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    override func setupViews() {
        super.setupViews()
        addShadow()
        backgroundColor = KTColors.Surface.primary.color
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                UILabel().then {
                    $0.text = KTStrings.Trip.totalPrice
                    $0.font = KTFonts.SFProText.medium.font(size: 14)
                    $0.textColor = KTColors.Text.primary.color
                    $0.setContentHuggingPriority(.init(1), for: .horizontal)
                    $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
                },
                priceLabel
            ]).then {
                $0.axis = .vertical
                $0.spacing = 4
            },
            bookButton
        ]).then {
            $0.alignment = .center
            $0.spacing = 12
        }
        
        add(stackView, {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(18)
            $0.leading.equalToSuperview().offset(18)
        })
        
        bookButton.snp.makeConstraints {
            $0.width.equalTo(120)
        }
    }
    
    func set(trip: KTTripAdapter) {
        priceLabel.attributedText = {
            let string: NSMutableAttributedString = .init(
                string: trip.formattedPrice ?? "-",
                attributes: [
                    .font: KTFonts.SFProText.bold.font(size: 30) as UIFont,
                    .foregroundColor: KTColors.Text.primary.color as UIColor
                ]
            )
            string.append(.init(
                string: KTStrings.Trip.slashPerson,
                attributes: [
                    .font: KTFonts.SFProText.medium.font(size: 15) as UIFont,
                    .foregroundColor: KTColors.Text.secondary.color as UIColor
                ]
            ))
            return string
        }()
    }
}
