//
//  KTTripsListViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class KTTripsListViewModel: KTViewModel {
    
    private let tripsService: KTTripsService = .init()
    
    private let collection: KTTripsCollection
    
    private let observableTrips: BehaviorRelay<[KTTripAdapter]> = .init(value: [])
    
    init(collection: KTTripsCollection) {
        self.collection = collection
        super.init()
        loadTrips()
    }
}

private extension KTTripsListViewModel {
        
    func loadTrips() {
        let adaptersQueue: DispatchQueue = .init(label: "KTTripsListViewModel.adapters_queue", qos: .default, attributes: .concurrent)
        var adapters: [KTTripAdapter] = []
        
        let group: DispatchGroup = .init()
        
        collection.trips.forEach { tripId in
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
            self?.observableTrips.accept(adapters)
        }
    }
}

extension KTTripsListViewModel: KTViewModelProtocol {
    
    struct Input {
        let selectTrip: Observable<KTTripAdapter>
    }
    
    struct Output {
        let name: Driver<String>
        let trips: Driver<[KTTripAdapter]>
    }
    
    func transform(input: Input) -> Output {
        input.selectTrip
            .map { KTTripDetailsScreen(viewModel: .init(trip: $0)) }
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        return .init(
            name: .just(collection.name[KTTripAdapter.shared] ?? ""),
            trips: observableTrips.asDriverOnErrorJustComplete()
        )
    }
}
