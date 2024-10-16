//
//  KTIconTextView.swift
//  Kettik
//
//  Created by Tami on 31.03.2024.
//

import UIKit

final class KTIconTextView: KTView {
    
    var font: UIFont {
        get {
            textLabel.font
        }
        set {
            textLabel.font = newValue
        }
    }
    
    var textColor: UIColor {
        get {
            textLabel.textColor
        }
        set {
            textLabel.textColor = newValue
        }
    }
    
    var iconColor: UIColor = .clear {
        didSet {
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = iconColor
        }
    }
    
    private let iconView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let textLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.medium.font(size: 14)
        $0.textColor = KTColors.Text.primary.color
        $0.numberOfLines = 0
    }
    
    override func setupViews() {
        super.setupViews()
        add(UIStackView(arrangedSubviews: [iconView, textLabel]).then {
            $0.alignment = .center
            $0.spacing = 4
        }, {
            $0.edges.equalToSuperview()
        })
    }
    
    func set(icon: UIImage) {
        iconView.image = icon
    }
    
    func set(text: String?) {
        textLabel.text = text
    }
}

