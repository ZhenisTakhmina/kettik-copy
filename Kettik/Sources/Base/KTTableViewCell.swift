//
//  KTTableViewCell.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit
import RxSwift

class KTTableViewCell: UITableViewCell {
    
    var disposeBag: DisposeBag = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        bind()
    }
    
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
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

