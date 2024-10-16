//
//  KTFavouritesScreen.swift
//  Kettik
//
//  Created by Tami on 23.03.2024.
//

import UIKit
import RxCocoa
import RxSwift

final class KTFavouritesScreen: KTViewController {
    
    private let viewModel: KTFavouritesViewModel = .init()
    
    private let selectTrip: PublishRelay<KTTripAdapter> = .init()
    
    private var trips: [KTTripAdapter] = []
    
    private lazy var tableView: UITableView = .init().then {
        $0.register(Cell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.tableFooterView = .init()
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Profile.favourites
        
        view.add(tableView) {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTFavouritesViewModel.Input = .init(
            loadData: rx.viewWillAppear.mapToVoid(),
            selectTrip: selectTrip.asObservable()
        )
        let output: KTFavouritesViewModel.Output = viewModel.transform(input: input)
        
        output.trips
            .drive(onNext: { [weak self] trips in
                guard let self = self else { return }
                self.trips = trips
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTFavouritesScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(trip: trips[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectTrip.accept(trips[indexPath.row])
    }
}

fileprivate final class Cell: KTTableViewCell {
    
    private let photoView: UIImageView = .init().then {
        $0.backgroundColor = KTColors.Surface.secondary.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 18)
        $0.textColor = KTColors.Text.primary.color
    }
    
    private let locationView: KTIconTextView = .init().then {
        $0.set(icon: KTImages.Icon.locationSmall.image)
        $0.iconColor = KTColors.Brand.blue.color
        $0.textColor = KTColors.Brand.blue.color
        $0.font = KTFonts.SFProText.regular.font(size: 12)
    }
    
    private let priceLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 16)
        $0.textColor = KTColors.Text.primary.color
    }
    
    override func setupViews() {
        super.setupViews()
        addShadow()
        layer.shadowOffset = .init(width: 0, height: 12)
        
        let containerView: KTView = .init(backgroundColor: KTColors.Surface.primary.color).then {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            photoView,
            UIStackView(arrangedSubviews: [
                nameLabel,
                locationView,
                priceLabel
            ]).then {
                $0.axis = .vertical
                $0.spacing = 4
                $0.setCustomSpacing(12, after: locationView)
            }
        ]).then {
            $0.alignment = .center
            $0.spacing = 24
        }
        
        contentView.add(containerView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 18, vertical: 6))
        })
        containerView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 14, vertical: 12))
        })
        photoView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 80))
        }
    }
    
    func set(trip: KTTripAdapter) {
        photoView.setImage(with: trip.thumbnailURL)
        nameLabel.text = trip.name?[KTTripAdapter.shared]
        priceLabel.text = trip.formattedPrice
        locationView.set(text: trip.location?[KTTripAdapter.shared])
    }
}
