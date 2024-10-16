//
//  KTScrollableViewController.swift
//  Kettik
//
//  Created by Tami on 04.03.2024.
//

import UIKit
import SnapKit

class KTScrollableViewController: KTViewController {
    
    let scrollView: UIScrollView = {
        let view: UIScrollView = .init()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let contentView: KTView = {
        let view: KTView = .init()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.init(floatLiteral: 1))
            $0.edges.equalToSuperview()
        }
    }
}

