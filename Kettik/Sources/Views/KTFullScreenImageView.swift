//
//  KTFullScreenImageView.swift
//  Kettik
//
//  Created by Tami on 11.05.2024.
//

import UIKit

final class KTFullScreenImageViewController: KTViewController {
    
    private let imageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let closeButton: KTImageButton = .init(image: KTImages.Illustration.xCircle.image)
    
    override func setupViews() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        view.add(closeButton, {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(CGSize(width: 50, height: 50))
        })
        view.add(imageView, {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(400)
            $0.width.equalTo(350)
        })
        
    }
    
    override func bind() {
        super.bind()
        
        closeButton.rx.tap.mapToVoid()
            .bind(onNext: { [unowned self] in
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    func setImage(_ image: URL?) {
        imageView.setImage(with: image)
    }
}
