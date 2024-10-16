//
//  FBSnapshotInitializable.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import FirebaseFirestore

protocol FBSnapshotInitializable {
    
    init?(documentSnapshot: DocumentSnapshot?)
}

