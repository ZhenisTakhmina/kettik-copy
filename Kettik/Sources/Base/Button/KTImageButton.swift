//
//  KTImageButton.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit

final class KTImageButton: KTButton {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.24, animations: {
                self.transform = self.isHighlighted ? .init(scaleX: 0.8, y: 0.8) : .identity
            })
        }
    }
    
    init(image: UIImage, renderingMode: UIImage.RenderingMode = .alwaysOriginal) {
        super.init()
        setImage(image.withRenderingMode(renderingMode), for: .normal)
    }
}
