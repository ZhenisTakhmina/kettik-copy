//
//  KTUser.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import FirebaseFirestore

class KTUser: FBSnapshotInitializable {
    
    let id: String
    var fullName: String?
    
    required init?(documentSnapshot: DocumentSnapshot?) {
        guard let id = documentSnapshot?.documentID else { return nil }
        
        let fullName: String? = documentSnapshot?.data()?["full_name"] as? String
        
        self.id = id
        self.fullName = fullName
    }
}
