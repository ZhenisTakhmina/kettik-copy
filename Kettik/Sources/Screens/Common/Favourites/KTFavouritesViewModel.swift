//
//  KTFavouritesViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class KTFavouritesViewModel: KTViewModel {
    
    private let tripsService: KTTripsService = .init()
    
    private let observableTrips: BehaviorRelay<[KTTripAdapter]> = .init(value: [])
}

private extension KTFavouritesViewModel {
        
    func loadTrips() {
        let adaptersQueue: DispatchQueue = .init(label: "KTTripsListViewModel.adapters_queue", qos: .default, attributes: .concurrent)
        var adapters: [KTTripAdapter] = []
        
        let group: DispatchGroup = .init()
        
        defaultLoading.accept(true)
        dataService.getFavourites().forEach { tripId in
            group.enter()
            tripsService.rxGetTrip(id: tripId)
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                .map {
                    KTTripAdapter(trip: $0)
                }
                .subscribe { trip in
                    adaptersQueue.async(flags: .barrier, execute: {
                        adapters.append(trip)
                        group.leave()
                    })
                } onFailure: { _ in
                    group.leave()
                }
                .disposed(by: disposeBag)
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            self.defaultLoading.accept(false)
            self.observableTrips.accept(adapters)
        }
    }
}

extension KTFavouritesViewModel: KTViewModelProtocol {
    
    struct Input {
        let loadData: Observable<Void>
        let selectTrip: Observable<KTTripAdapter>
    }
    
    struct Output {
        let trips: Driver<[KTTripAdapter]>
    }
    
    func transform(input: Input) -> Output {
        input.loadData
            .bind(onNext: { [unowned self] in
                loadTrips()
            })
            .disposed(by: disposeBag)
        
        input.selectTrip
            .map { KTTripDetailsScreen(viewModel: .init(trip: $0)) }
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        return .init(
            trips: observableTrips.asDriverOnErrorJustComplete()
        )
    }
}

