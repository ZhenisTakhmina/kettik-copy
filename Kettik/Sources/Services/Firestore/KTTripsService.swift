//
//  KTTripsService.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import RxCocoa
import RxSwift

final class KTTripsService: KTFirebaseServiceType {
    
    @Injected(\.dataService) var dataService: KTDataService
    
    var collection: String {
        "trips"
    }
}

extension KTTripsService {
    
    func rxGetTrip(id: String) -> Single<KTTrip> {
        if let trip = dataService.getTrip(id: id) {
            return Single.just(trip)
        } else {
            return rxMapDocument(id: id)
                .map { [weak self] trip in
                    self?.dataService.set(trip: trip)
                    return trip
                }
        }
    }
    
    func rxSearchTrips(tag: String) -> Single<[KTTripAdapter]> {
        rxGetDocuments(query: getCollectionReference().whereField("search_tags", arrayContains: tag.lowercased()))
            .map { snapshots in
                let trips: [KTTripAdapter] = snapshots
                    .compactMap { KTTrip(documentSnapshot: $0) }
                    .map { .init(trip: $0) }
                return trips
            }
    }
}
