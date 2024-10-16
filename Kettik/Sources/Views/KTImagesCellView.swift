//
//  KTImagesCellView.swift
//  Kettik
//
//  Created by Tami on 11.05.2024.
//

import UIKit

final class KTImagesCellView: KTView {
    
    private let imageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    override func setupViews() {
        add(imageView, {
            $0.edges.equalToSuperview()
        })
    }
    
}

extension KTImagesCellView {
    func set(image: URL?) {
        imageView.setImage(with: image)
    }
}
