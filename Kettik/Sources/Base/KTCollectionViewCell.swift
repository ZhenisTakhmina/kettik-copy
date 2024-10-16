//
//  KTCollectionViewCell.swift
//  Kettik
//
//  Created by Tami on 11.03.2024.
//

import UIKit
import RxSwift

class KTCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bind()
    }
    
    func setupViews() {
        backgroundColor = .clear
    }
    
    func bind() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


