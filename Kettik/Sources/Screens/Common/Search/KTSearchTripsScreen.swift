//
//  KTSearchTripsScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI

final class KTSearchTripsScreen: KTViewController {
    
    private enum Constants {
        
        static let cellHeight: CGFloat = 200
    }
    
    private let viewModel: KTSearchTripsViewModel = .init()
    
    private var trips: [KTTripAdapter] = []
    
    private let selectTrip: PublishRelay<KTTripAdapter> = .init()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.sectionInset = .init(top: 24, left: 0, bottom: 0, right: 0)
        let view: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isUserInteractionEnabled = true
        view.allowsSelection = true
        view.register(TripCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override init() {
        super.init()
        modalPresentationStyle = .formSheet
    }
    
    private let searchField: UITextField = .init().then {
        $0.borderStyle = .none
        $0.font = KTFonts.SFProText.regular.font(size: 16)
        $0.textColor = KTColors.Text.primary.color
        $0.attributedPlaceholder = .init(string: KTStrings.Explore.searchText, attributes: [.font: KTFonts.SFProText.regular.font(size: 16) as UIFont, .foregroundColor: KTColors.Text.secondary.color as UIColor])
        $0.leftView = {
            let iconView: UIImageView = .init(image: KTImages.Icon.search.image).then {
                $0.contentMode = .scaleAspectFit
            }
            let view: UIView = .init()
            
            view.addSubview(iconView)
            view.snp.makeConstraints {
                $0.size.equalTo(32)
            }
            iconView.snp.makeConstraints {
                $0.size.equalTo(12)
                $0.center.equalToSuperview()
            }
            
            return view
        }()
        $0.rightView = .init().then {
            $0.snp.makeConstraints { m in m.size.equalTo(12) }
        }
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = KTColors.Text.secondary.color.withAlphaComponent(0.2).cgColor
        $0.layer.borderWidth = 1
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    override func setupViews() {
        super.setupViews()
        view.add(searchField, {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        })
        view.add(collectionView, {
            $0.top.equalTo(searchField.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        rx.viewWillAppear
            .mapToVoid()
            .bind(onNext: { [unowned self] in
                searchField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        let input: KTSearchTripsViewModel.Input = .init(
            search: searchField.rx.text.asObservable(),
            selectTrip: selectTrip.asObservable()
        )
        let output: KTSearchTripsViewModel.Output = viewModel.transform(input: input)
        
        output.trips
            .drive(onNext: { [weak self] trips in
                guard let self = self else { return }
                self.trips = trips
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTSearchTripsScreen: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

