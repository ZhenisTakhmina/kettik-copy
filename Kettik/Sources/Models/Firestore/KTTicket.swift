//
//  KTTicket.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation
import FirebaseFirestore

struct KTTicket: FBSnapshotInitializable {
    
    let id: String
    let tripId: String
    let name: String
    let totalPrice: Int
    let count: Int
    let purchaseDate: Date
    let status: String

    
    init?(documentSnapshot: DocumentSnapshot?) {
        guard 
            let id = documentSnapshot?.documentID,
            let tripId = documentSnapshot?.data()?["trip_id"] as? String,
            let name = documentSnapshot?.data()?["name"] as? String,
            let totalPrice = documentSnapshot?.data()?["total_price"] as? Int,
            let count = documentSnapshot?.data()?["count"] as? Int,
            let purchaseDate = documentSnapshot?.data()?["purchase_date"] as? Timestamp,
            let status = documentSnapshot?.data()?["status"] as? String

        else { return nil }
        
        self.id = id
        self.tripId = tripId
        self.name = name
        self.totalPrice = totalPrice
        self.count = count
        self.purchaseDate = purchaseDate.dateValue()
        self.status = status
    }
}
