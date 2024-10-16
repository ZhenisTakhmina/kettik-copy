//
//  KTTripsCollectionsService.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

final class KTTripsCollectionsService: KTFirebaseServiceType {
    
    @Injected(\.dataService) var dataService: KTDataService
    
    var collection: String {
        "trips_collections"
    }
}

extension KTTripsCollectionsService {
    
    func rxGetCollection(id: String) -> Single<KTTripsCollection> {
        rxMapDocument(id: id)
    }
    
    func rxGetCollections() -> Single<[KTTripsCollection]> {
        rxGetDocuments()
            .map { documents in
                let collections: [KTTripsCollection] = documents
                    .compactMap { .init(documentSnapshot: $0) }
                
                return collections
            }
    }
}
