//
//  KTFullScreenLoadingView.swift
//  Kettik
//
//  Created by Tami on 01.04.2024.
//

import UIKit

final class KTFullScreenLoadingView: KTView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        setContentHuggingPriority(.init(1), for: .vertical)
        setContentCompressionResistancePriority(.init(1), for: .vertical)
        setContentHuggingPriority(.init(1), for: .horizontal)
        setContentCompressionResistancePriority(.init(1), for: .horizontal)
        
        backgroundColor = KTColors.Surface.primary.color.withAlphaComponent(0.4)
        
        let spinnerView: KTSpinnerView = .init()
        addSubview(spinnerView)
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(64)
        }
    }
}

