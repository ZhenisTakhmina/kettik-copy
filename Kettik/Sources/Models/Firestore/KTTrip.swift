//
//  KTTrip.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import FirebaseFirestore

struct KTTrip: FBSnapshotInitializable {
    
    let id: String
    let name: [String:String]?
    let location: [String:String]?
    let price: Int?
    let date: String?
    let description: [String:String]?
    let thumbnail: String?
    let images: [String]?
    let difficulty: String?
    let duration: [String:String]?
    
    init?(documentSnapshot: DocumentSnapshot?) {
        guard let id = documentSnapshot?.documentID else { return nil }
        
        let name: [String:String]? = documentSnapshot?.data()?["name"] as? [String:String]
        let location: [String:String]? = documentSnapshot?.data()?["location"] as? [String:String]
        let date: String? = documentSnapshot?.data()?["date"] as? String
        let price: Int? = documentSnapshot?.data()?["price"] as? Int
        let description: [String:String]? = documentSnapshot?.data()?["description"] as? [String:String]
        let thumbnail: String? = documentSnapshot?.data()?["thumbnail"] as? String
        let images: [String]? = documentSnapshot?.data()?["images"] as? [String]
        let difficulty: String? = documentSnapshot?.data()?["difficulty"] as? String
        let duration: [String:String]? = documentSnapshot?.data()?["duration"] as? [String:String]
        
        self.id = id
        self.name = name
        self.location = location
        self.price = price
        self.description = description
        self.thumbnail = thumbnail
        self.images = images
        self.difficulty = difficulty
        self.date = date
        self.duration = duration
    }
}
