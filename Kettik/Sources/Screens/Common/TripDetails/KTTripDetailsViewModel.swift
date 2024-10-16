//
//  KTTripDetailsViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxCocoa
import RxSwift

final class KTTripDetailsViewModel: KTViewModel {
    
    private let trip: KTTripAdapter
    
    private var observableIsFavourite: BehaviorRelay<Bool>!
    
    init(trip: KTTripAdapter) {
        self.trip = trip
        super.init()
        observableIsFavourite = .init(value: dataService.isFavourite(tripId: trip.id))
    }
}
private extension KTTripDetailsViewModel {
    
    func toggleFavourite() {
        let isFavourite: Bool = dataService.isFavourite(tripId: trip.id)
        
        defaultLoading.accept(true)
        
        let request: Single<Void> = isFavourite
            ? dataService.rxRemoveFromFavourite(tripId: trip.id)
            : dataService.rxAddToFavourite(tripId: trip.id)
        
        request
            .subscribe(onSuccess: { [weak self] in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.observableIsFavourite.accept(!isFavourite)
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func handleSuccessPurchase(ticket: KTTicketAdapter) {
        let screen: KTTicketScreen = .init(ticket: ticket)
        defaultPresentViewController.accept(.init(controller: screen, animated: true))
    }
    
    func proceedToOrder() {
        let viewModel: KTOrderViewModel = .init(
            trip: trip,
            onSuccess: { [weak self] ticket in
                self?.handleSuccessPurchase(ticket: ticket)
            }
        )
        let screen: KTOrderScreen = .init(viewModel: viewModel)
        defaultPresentViewController.accept(.init(controller: screen, animated: true))
    }
}

extension KTTripDetailsViewModel: KTViewModelProtocol {
    
    struct Input {
        let back: Observable<Void>
        let toggleFavourite: Observable<Void>
        let order: Observable<Void>
    }
    
    struct Output {
        let isFavourite: Driver<Bool>
        let displayTrip: Driver<KTTripAdapter>
    }
    
    func transform(input: Input) -> Output {
        input.back
            .bind(to: defaultPopViewController)
            .disposed(by: disposeBag)
        
        input.toggleFavourite
            .bind(onNext: { [unowned self] in
                toggleFavourite()
            })
            .disposed(by: disposeBag)
        
        input.order
            .bind(onNext: { [unowned self] in
                proceedToOrder()
            })
            .disposed(by: disposeBag)
        
        return .init(
            isFavourite: observableIsFavourite.asDriverOnErrorJustComplete(),
            displayTrip: .just(trip)
        )
    }
}
