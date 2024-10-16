//
//  KTFAQScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI

final class KTFAQScreen: KTScrollableViewController {
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Profile.faq
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            KTAccordionView(title: "What are the best months for mountain hiking?", text: "The best months for mountain hiking typically depend on the specific region and elevation. In general, late spring to early fall is ideal when weather conditions are milder and trails are more accessible. However, always check local weather forecasts and trail conditions before planning your hike."),
            KTAccordionView(title: "How can I prepare physically for a mountain hike?", text: "Start with shorter hikes, incorporate cardio and strength training, and gradually increase intensity."),
            KTAccordionView(title: "What to take with you", text: "You need to take: \n a small backpack (30 liters),trekking poles,raincoat (no matter what forecast is, it is better to take it),cap,sunglasses,camping mats for the rest,trekking shoes,lightweight sportswear.For hike in the high mountains of over 3,000 meters you should always take warm clothes, for other tours it depends on the weather forecast and season.Passport is needed during the hiking."),
        ]).then {
            $0.axis = .vertical
        }
        
        contentView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 24, vertical: 14))
        })
    }
}


