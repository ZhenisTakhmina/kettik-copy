//
//  KTUsersService.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore

final class KTUsersService: KTFirebaseServiceType {
    
    @Injected(\.authorizationService) var authorizationService: KTAuthorizationService
    
    var collection: String {
        "users"
    }
}

extension KTUsersService {
    
    func rxUpdateProfile(fullName: String) -> Single<Void> {
        guard let id = authorizationService.userId else {
            return .error(KTError.unknown)
        }
        
        return Single<Void>.create { [unowned self] single in
            getCollectionReference()
                .document(id)
                .setData(["full_name": fullName], merge: true) { [unowned self] error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        authorizationService.currentUserProfile?.fullName = fullName
                        single(.success(()))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func rxGetTickets() -> Single<[KTTicketAdapter]> {
        guard let id = authorizationService.userId else {
            return .error(KTError.unknown)
        }
        
        return Single<[KTTicketAdapter]>.create { [unowned self] single in
            getCollectionReference()
                .document(id)
                .collection("tickets")
                .getDocuments(completion: { snapshot, error in
                    if let snapshot = snapshot {
                        let tickets: [KTTicketAdapter] = snapshot.documents
                            .compactMap { KTTicket(documentSnapshot: $0) }
                            .map { KTTicketAdapter(ticket: $0)}
                        
                        single(.success(tickets))
                    } else if let error = error {
                        single(.failure(error))
                    } else {
                        single(.failure(KTError.parsingError))
                    }
                })
            
            return Disposables.create()
        }
    }
    
    func rxBuyTickets(
        name: String,
        phoneNumber: String,
        count: Int,
        totalPrice: Int,
        trip: KTTripAdapter
    ) -> Single<KTTicketAdapter> {
        guard let id = authorizationService.userId else {
            return .error(KTError.unknown)
        }
        
        return Single<KTTicketAdapter>.create { [unowned self] single in
            
            let reference: CollectionReference = getCollectionReference()
                .document(id)
                .collection("tickets")
            
            let document: DocumentReference = reference.document()
            
            document
                .setData([
                        "full_name": name,
                        "phone_number": phoneNumber,
                        "trip_id": trip.id,
                        "total_price": totalPrice,
                        "count": count,
                        "status": "В обработке",
                        "paymentStatus": "Ожидает оплаты",
                        "name": trip.name?[KTTripAdapter.shared] ?? "-",
                        "purchase_date": Timestamp(date: .init())
                    ]) { error in
                        if let error = error {
                            single(.failure(error))
                        } else {
                            single(.success(.init(
                                id: document.documentID,
                                tripId: trip.id,
                                name: trip.name?[KTTripAdapter.shared] ?? "-",
                                formattedTotalPrice: totalPrice.kztFormatted,
                                count: count,
                                purchaseDate: Date(),
                                status: "pending"
                            )))
                        }
                    }
            return Disposables.create()
        }
    }
}
