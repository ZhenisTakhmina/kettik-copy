//
//  KTPrimaryButton.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit

final class KTPrimaryButton: KTButton {
    
    init(title: String) {
        super.init()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        setTitle(title, for: .normal)
        titleLabel?.font = KTFonts.SFProText.semibold.font(size: 16)
        tintColor = .white
        
        setBackgroundColor(color: KTColors.Brand.accent.color, forState: .normal)
        snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
}
