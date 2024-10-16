//
//  KTHorizontalTripsView.swift
//  Kettik
//
//  Created by Tami on 28.03.2024.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

final class KTHorizontalTripsView: KTView {
    
    private enum Constants {
        
        static let listCellSize: CGSize = .init(width: 220, height: 140)
        static let blockCellSize: CGSize = .init(width: 0, height: 160)
    }
    
    var selectTrip: Observable<KTTripAdapter> {
        _selectTrip.asObservable()
    }
    
    private var _selectTrip: PublishRelay<KTTripAdapter> = .init()
    
    private let viewModel: KTHorizontalTripsViewModel
    
    private var trips: [KTTripAdapter] = []
    
    private var style: KTTripsCollectionStyle {
        viewModel.collection.style
    }
    
    private let titleLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.medium.font(size: 18)
        $0.textColor = KTColors.Text.primary.color
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(horizontal: 18, vertical: 0)
        let view: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(TripCell.self)
        view.dataSource = self
        view.delegate = self
        view.clipsToBounds = false
        return view
    }()
    
    let viewAllButton: KTViewAllButton = .init()
    
    init(viewModel: KTHorizontalTripsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupViews() {
        super.setupViews()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        let titleView: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            viewAllButton
        ]).then {
            $0.alignment = .center
            $0.spacing = 8
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleView,
            collectionView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .center
        }
        
        switch style {
        case .list:
            collectionView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(Constants.listCellSize.height)
            }
        case .block:
            collectionView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(Constants.blockCellSize.height)
            }
        }
        
        add(stackView) {
            $0.edges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(18)
        }
    }
    
    override func bind() {
        super.bind()
        let input: KTHorizontalTripsViewModel.Input = .init()
        let output: KTHorizontalTripsViewModel.Output = viewModel.transform(input: input)
        
        output.name
            .drive(onNext: { [weak self] name in
                self?.titleLabel.text = name
            })
            .disposed(by: disposeBag)
        
        output.trips
            .drive(onNext: { [weak self] trips in
                guard let self = self else { return }
                switch self.style {
                case .list:
                    self.trips = trips
                case .block:
                    self.trips = !trips.isEmpty ? [trips.first.unsafelyUnwrapped] : []
                }
                
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTHorizontalTripsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TripCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(trip: trips[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch style {
        case .block: 
            return .init(width: bounds.width - 36, height: Constants.blockCellSize.height)
        case .list: 
            return Constants.listCellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selectTrip.accept(trips[indexPath.item])
    }
}

fileprivate final class TripCell: KTCollectionViewCell {
    
    private let tripView: KTTripCellView = .init()
    
    override func setupViews() {
        super.setupViews()
        contentView.add(tripView, {
            $0.edges.equalToSuperview()
        })
    }
    
    func set(trip: KTTripAdapter) {
        tripView.set(trip: trip)
    }
}


