//
//  KTCountControl.swift
//  Kettik
//
//  Created by Tami on 10.04.2024.
//

import UIKit

final class KTCountControl: KTView {
    
    var isEnabled: Bool = true {
        didSet {
            decButton.isEnabled = isEnabled
            incButton.isEnabled = isEnabled
        }
    }
    
    private let countLabel: UILabel = .init().then {
        $0.text = "1"
        $0.font = KTFonts.SFProText.bold.font(size: 22)
        $0.textColor = KTColors.Text.primary.color
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    let decButton: KTImageButton = .init(image: KTImages.Control.decrement.image)
    
    let incButton: KTImageButton = .init(image: KTImages.Control.increment.image)
    
    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = KTColors.Surface.secondary.color
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            decButton,
            countLabel,
            incButton
        ]).then {
            $0.spacing = 8
        }
        
        add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 8, vertical: 8))
        })
        snp.makeConstraints {
            $0.height.equalTo(62)
        }
    }
    
    func set(count: Int) {
        countLabel.text = "\(count)"
    }
}
