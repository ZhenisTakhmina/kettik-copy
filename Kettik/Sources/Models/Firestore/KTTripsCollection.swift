//
//  KTTripsCollection.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import FirebaseFirestore

struct KTTripsCollection: FBSnapshotInitializable {
    
    let id: String
    let name: [String:String]
    let trips: [String]
    let sortIndex: Int
    let style: KTTripsCollectionStyle
    
    init(id: String, name: [String:String], trips: [String], sortIndex: Int?, style: KTTripsCollectionStyle) {
        self.id = id
        self.name = name
        self.trips = trips
        self.sortIndex = sortIndex ?? 0
        self.style = style
    }
    
    init?(documentSnapshot: DocumentSnapshot?) {
        guard 
            let id = documentSnapshot?.documentID,
            let name: [String:String] = documentSnapshot?.data()?["name"] as? [String:String],
            let trips: [String] = documentSnapshot?.data()?["trips"] as? [String]
        else { return nil }
        
        let sortIndex: Int = documentSnapshot?.data()?["sort_index"] as? Int ?? 0
        let style: KTTripsCollectionStyle = KTTripsCollectionStyle(rawValue: documentSnapshot?.data()?["style"] as? String ?? "") ?? .list
        
        self.id = id
        self.name = name
        self.trips = trips
        self.sortIndex = sortIndex
        self.style = style
    }
}
