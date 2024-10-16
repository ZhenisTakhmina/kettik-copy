//
//  KTTicketKeyValueView.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit

final class KTTicketKeyValueView: KTView {
    
    let valueLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 16)
        $0.textColor = KTColors.Text.primary.color
        $0.text = "-"
    }
    
    init(title: String) {
        super.init()
        let titleLabel: UILabel = .init().then {
            $0.text = title
            $0.font = KTFonts.SFProText.semibold.font(size: 14)
            $0.textColor = KTColors.Text.secondary.color
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            valueLabel
        ]).then {
            $0.axis = .vertical
            $0.spacing = 2
        }
        
        add(stackView, {
            $0.edges.equalToSuperview()
        })
    }
    
    func set(value: String?) {
        valueLabel.text = value ?? "-"
    }
}
