//
//  KTTripCellView.swift
//  Kettik
//
//  Created by Tami on 28.04.2024.
//

import UIKit
import SwiftUI

final class KTTripCellView: KTView {
    
    private let thumbnailView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let priceLabel: UILabel = .init().then {
        $0.textColor = .white
        $0.font = KTFonts.SFProText.bold.font(size: 12)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let nameLabel: UILabel = .init().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = KTFonts.SFProText.bold.font(size: 12)
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
    }
    
    let locationLabel: UILabel = .init().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = KTFonts.SFProText.regular.font(size: 10)
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
    }
    
    let locationView: KTIconTextView = .init().then {
        $0.set(icon: KTImages.Icon.locationSmall.image)
        $0.font = KTFonts.SFProText.regular.font(size: 10)
        $0.textColor = .white
    }
    
    let difficultyView: KTDifficultyView = .init()
    
    override func setupViews() {
        super.setupViews()
        addShadow()
        
        let containerView: KTView = .init(backgroundColor: KTColors.Surface.secondary.color).then {
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
        }
        
        let nameStackView: UIStackView = .init(arrangedSubviews: [
            nameLabel,
            locationView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        let priceStackView: UIStackView = .init(arrangedSubviews: [
            priceLabel,
            difficultyView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .trailing
        }
        
        let footerStackView: UIStackView = .init(arrangedSubviews: [
            nameStackView,
            priceStackView
        ]).then {
            $0.alignment = .center
            $0.spacing = 8
        }
        
        let gradientView: UIImageView = .init(image: KTImages.Element.blackGradient.image).then {
            $0.contentMode = .scaleToFill
        }
        
        add(containerView) {
            $0.edges.equalToSuperview()
        }
        containerView.add(thumbnailView) {
            $0.edges.equalToSuperview()
        }
        thumbnailView.add(gradientView, {
            $0.edges.equalToSuperview()
        })

        containerView.add(footerStackView, {
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(14)
        })
        difficultyView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 68, height: 22))
        }
    }
}

extension KTTripCellView {
    
    func set(trip: KTTripAdapter) {
        
        thumbnailView.setImage(with: trip.thumbnailURL)
        nameLabel.text = trip.name?[KTTripAdapter.shared]
        locationView.set(text: trip.location?[KTTripAdapter.shared])
        priceLabel.text = trip.formattedPrice
        if let difficulty = trip.difficulty {
            difficultyView.set(difficulty: difficulty)
            difficultyView.isHidden = false
        } else {
            difficultyView.isHidden = true
        }
    }
}
