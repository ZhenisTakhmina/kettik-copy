//
//  KTTripsListScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

final class KTTripsListScreen: KTViewController {
    
    private enum Constants {
        
        static let cellHeight: CGFloat = 200
    }
    
    private let viewModel: KTTripsListViewModel
    
    private var trips: [KTTripAdapter] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        let view: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.register(TripCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let selectTrip: PublishRelay<KTTripAdapter> = .init()
    
    init(viewModel: KTTripsListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupViews() {
        super.setupViews()
        view.add(collectionView, {
            $0.edges.equalToSuperview()
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTTripsListViewModel.Input = .init(selectTrip: selectTrip.asObservable())
        let output: KTTripsListViewModel.Output = viewModel.transform(input: input)
        
        output.name
            .drive(onNext: { [weak self] name in
                self?.navigationItem.title = name
            })
            .disposed(by: disposeBag)
        
        output.trips
            .drive(onNext: { [weak self] trips in
                guard let self = self else { return }
                self.trips = trips
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTTripsListScreen: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TripCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(trip: trips[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width, height: Constants.cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectTrip.accept(trips[indexPath.item])
    }
}


fileprivate final class TripCell: KTCollectionViewCell {
    
    private let tripView: KTTripCellView = .init().then {
        $0.nameLabel.font = KTFonts.SFProText.bold.font(size: 16)
        $0.locationView.font = KTFonts.SFProText.regular.font(size: 14)
        $0.priceLabel.font = KTFonts.SFProText.bold.font(size: 16)
    }
    
    override func setupViews() {
        super.setupViews()
        contentView.add(tripView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 18, vertical: 8))
        })
    }
    
    func set(trip: KTTripAdapter) {
        tripView.set(trip: trip)
    }
}


