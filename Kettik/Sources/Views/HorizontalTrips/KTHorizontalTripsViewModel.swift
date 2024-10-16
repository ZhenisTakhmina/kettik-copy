//
//  KTHorizontalTripsViewModel.swift
//  Kettik
//
//  Created by Tami on 28.03.2024.
//

import Foundation
import RxCocoa
import RxSwift

final class KTHorizontalTripsViewModel: KTViewModel {
    
    private let tripsService: KTTripsService = .init()
    
    let collection: KTTripsCollection
    
    private let observableTrips: BehaviorRelay<[KTTripAdapter]> = .init(value: [])
    
    init(collection: KTTripsCollection) {
        self.collection = collection
        super.init()
        loadTrips()
    }
}

private extension KTHorizontalTripsViewModel {
        
    func loadTrips() {
        let adaptersQueue: DispatchQueue = .init(label: "KTHorizontalTripsViewModel.adapters_queue", qos: .default, attributes: .concurrent)
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

extension KTHorizontalTripsViewModel: KTViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        let name: Driver<String>
        let style: Driver<KTTripsCollectionStyle>
        let trips: Driver<[KTTripAdapter]>
    }
    
    func transform(input: Input) -> Output {
        
        return .init(
            name: .just(collection.name[KTTripAdapter.shared] ?? ""),
            style: .just(collection.style),
            trips: observableTrips.asDriverOnErrorJustComplete()
        )
    }
}
