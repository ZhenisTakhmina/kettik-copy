//
//  KTDifficultyView.swift
//  Kettik
//
//  Created by Tami on 08.03.2024.
//

import UIKit

final class KTDifficultyView: KTView {
    
    var font: UIFont {
        get {
            difficultyLabel.font
        }
        set {
            difficultyLabel.font = newValue
        }
    }
    
    private let difficultyLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.medium.font(size: 12)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        add(difficultyLabel, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 4, vertical: 0))
        })
    }
    
    func set(difficulty: KTTripDifficulty) {
        difficultyLabel.text = difficulty.title
        backgroundColor = difficulty.color
    }
}
