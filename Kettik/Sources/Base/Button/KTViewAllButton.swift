//
//  KTTitleIconButton.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit

final class KTViewAllButton: KTButton {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.24, animations: {
                if self.isHighlighted {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.8
                } else {
                    self.transform = .identity
                    self.alpha = 1
                }
            })
        }
    }
    
    override init() {
        super.init()
        add(
            UIStackView(arrangedSubviews: [
                UILabel().then {
                    $0.text = KTStrings.Common.viewAll
                    $0.font = KTFonts.SFProText.medium.font(size: 12)
                    $0.textColor = KTColors.Brand.blue.color
                },
                UIImageView(image: KTImages.Control.arrowRightSmall.image).then {
                    $0.contentMode = .scaleAspectFit
                }
            ]).then {
                $0.alignment = .center
                $0.spacing = 4
                $0.isUserInteractionEnabled = false
            }
        ) {
            $0.edges.equalToSuperview()
        }
    }
}
