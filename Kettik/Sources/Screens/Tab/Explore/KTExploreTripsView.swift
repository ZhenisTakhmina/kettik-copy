//
//  KTExploreTripsView.swift
//  Kettik
//
//  Created by Tami on 25.02.2024.
//

import UIKit
import RxCocoa
import RxSwift

final class KTExploreTripsView: KTView {
    
    var selectTrip: Observable<KTTripAdapter> {
        _selectTrip.asObservable()
    }
    
    var showAll: Observable<KTTripsCollection> {
        _showAll.asObservable()
    }
    
    private var _selectTrip: PublishRelay<KTTripAdapter> = .init()
    private var _showAll: PublishRelay<KTTripsCollection> = .init()
    
    private let stackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 18
    }
    
    override func setupViews() {
        super.setupViews()
        add(stackView) {
            $0.edges.equalToSuperview()
        }
    }
}

extension KTExploreTripsView {
    
    func set(collections: [KTTripsCollection]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        collections
            .sorted(by: { $0.sortIndex < $1.sortIndex })
            .forEach { collection in
                let viewModel: KTHorizontalTripsViewModel = .init(collection: collection)
                let view: KTHorizontalTripsView = .init(viewModel: viewModel)
                view.selectTrip
                    .bind(to: _selectTrip)
                    .disposed(by: view.disposeBag)
                
                view.viewAllButton.rx.tap
                    .map { collection }
                    .bind(to: _showAll)
                    .disposed(by: view.disposeBag)
                
                stackView.addArrangedSubview(view)
            }
    }
}
