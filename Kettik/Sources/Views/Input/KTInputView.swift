//
//  KTInputView.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import UIKit

class KTInputView: KTView {
    
    let title: String
    
    let textField: UITextField = .init().then {
        $0.borderStyle = .none
        $0.textColor = KTColors.Text.primary.color
        $0.font = KTFonts.SFProText.regular.font(size: 16)
        $0.leftView = UIView().then {
            $0.snp.makeConstraints { m in m.size.equalTo(CGSize(width: 20, height: 0)) }
        }
        $0.rightView = UIView().then {
            $0.snp.makeConstraints { m in m.size.equalTo(CGSize(width: 20, height: 0)) }
        }
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = KTColors.Text.secondary.color.withAlphaComponent(0.2).cgColor
    }
    
    init(title: String) {
        self.title = title
        super.init()
    }
    
    override func setupViews() {
        super.setupViews()
        let stackView: UIStackView = .init(arrangedSubviews: [
            UILabel().then {
                $0.text = title
                $0.font = KTFonts.SFProText.regular.font(size: 16)
                $0.textColor = KTColors.Text.primary.color
            },
            textField
        ]).then {
            $0.axis = .vertical
            $0.spacing = 8
        }
        
        add(stackView, {
            $0.edges.equalToSuperview()
        })
        textField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

extension KTInputView {
    
    func set(placeholder: String) {
        textField.attributedPlaceholder = .init(
            string: placeholder,
            attributes: [
                .font: KTFonts.SFProText.regular.font(size: 14) as UIFont,
                .foregroundColor: KTColors.Text.secondary.color as UIColor
            ]
        )
    }
}
