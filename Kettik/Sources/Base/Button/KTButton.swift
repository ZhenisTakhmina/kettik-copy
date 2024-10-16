//
//  KTButton.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit

class KTButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable, message: "Unavailable")
    public required init?(coder aDecoder: NSCoder) { fatalError("Unavailable") }
}

private extension KTButton {
    
    func commonInit() {
        
    }
}
