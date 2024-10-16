//
//  KTGoogleButton.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit

final class KTGoogleButton: KTButton {
    
    init(title: String) {
        super.init()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = KTColors.Text.secondary.color.cgColor
        layer.borderWidth = 0.5
        
        setTitle(title, for: .normal)
        titleLabel?.font = KTFonts.SFProText.semibold.font(size: 16)
        setTitleColor(KTColors.Text.secondary.color, for: .normal)
        tintColor = .white
        setImage(KTImages.Profile.google.image, for: .normal)
        semanticContentAttribute = .forceLeftToRight
        
        setBackgroundColor(color: .white, forState: .normal)
        snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
}
