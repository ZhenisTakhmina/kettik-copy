//
//  KTAccordionView.swift
//  Kettik
//
//  Created by Tami on 03.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class KTAccordionView: KTView {
    
    private let titleLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 16)
        $0.textColor = KTColors.Text.primary.color
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    private let textLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 16)
        $0.textColor = KTColors.Text.secondary.color
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private let toggleButton: KTImageButton = .init(image: KTImages.Control.plus.image)
    
    private let bottomDivider: KTView = .init(backgroundColor: KTColors.Text.secondary.color.withAlphaComponent(0.2))
    
    convenience init(title: String, text: String) {
        self.init()
        
        titleLabel.text = title
        textLabel.text = text
    }
 
    override func setupViews() {
        super.setupViews()
        let topDivider: KTView = .init(backgroundColor: KTColors.Text.secondary.color.withAlphaComponent(0.2))
        
        
        let titleStackView: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            toggleButton
        ]).then {
            $0.alignment = .center
            $0.spacing = 8
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleStackView,
            textLabel
        ]).then {
            $0.axis = .vertical
            $0.spacing = 28
            $0.alignment = .center
        }
        
        add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 0, vertical: 14))
        })
        add(topDivider, {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(1)
        })
        add(bottomDivider, {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(1)
        })
        
        titleStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        textLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(24)
        }
    }
    
    override func bind() {
        super.bind()
        Observable.merge(
            toggleButton.rx.tap.mapToVoid(),
            titleLabel.rx.observableTap
        )
            .map { [unowned self] in !textLabel.isHidden }
            .bind(onNext: { [unowned self] isExpanded in
                UIView.animate(withDuration: 0.24, animations: {
                    self.textLabel.isHidden = isExpanded
                })
            })
            .disposed(by: disposeBag)
    }
}
