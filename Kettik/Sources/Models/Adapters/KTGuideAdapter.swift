//
//  KTGuideAdapter.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation

struct KTGuideAdapter {
    
    let id: String
    let name: String?
    let role: String?
    let photoURL: URL?
    let description: String?
    let imagesURL: [URL]?
    
    init(id: String, name: String?, role: String?, photoURL: URL?, description: String?, imagesURL:[URL]?) {
        self.id = id
        self.name = name
        self.role = role
        self.photoURL = photoURL
        self.description = description
        self.imagesURL = imagesURL
    }
    
    init(guide: KTGuide) {
        self.id = guide.id
        self.name = guide.name
        self.role = guide.role
        self.photoURL = URL(string: guide.photo ?? "")
        self.description = guide.description
        self.imagesURL = guide.images?.compactMap{ URL(string: $0) }
    }
}
