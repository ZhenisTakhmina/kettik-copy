//
//  KTView.swift
//  Kettik
//
//  Created by Tami on 04.03.2024.
//

import UIKit
import RxSwift

class KTView: UIView {
    
    var disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        bind()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bind()
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func setupViews() {
        
    }
    
    func bind() {
        
    }

    @available(*, unavailable, message: "Unavailable")
    public required init?(coder aDecoder: NSCoder) { fatalError("Unavailable") }
}
