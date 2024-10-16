//
//  KTGuide.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation
import FirebaseFirestore

struct KTGuide: FBSnapshotInitializable {
    
    let id: String
    let name: String?
    let photo: String?
    let role: String?
    let description: String?
    let images: [String]?
    
    init(id: String, name: String?, photo: String?, role: String?, description: String?, images: [String]?) {
        self.id = id
        self.name = name
        self.photo = photo
        self.role = role
        self.description = description
        self.images = images
    }
    
    init?(documentSnapshot: DocumentSnapshot?) {
        guard let id = documentSnapshot?.documentID else { return nil }
        
        let name: String? = documentSnapshot?.data()?["name"] as? String
        let role: String? = documentSnapshot?.data()?["role"] as? String
        let description: String? = documentSnapshot?.data()?["description"] as? String
        let photo: String? = documentSnapshot?.data()?["photo"] as? String
        let images: [String]? = documentSnapshot?.data()?["images"] as? [String]
        
        self.id = id
        self.name = name
        self.role = role
        self.photo = photo
        self.description = description
        self.images = images
    }
}
