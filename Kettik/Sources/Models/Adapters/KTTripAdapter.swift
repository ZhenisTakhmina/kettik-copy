//
//  KTTripAdapter.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import Foundation

struct KTTripAdapter {
    
    static let shared = Locale.current.identifier
    
    let id: String
    let name: [String:String]?
    let description: [String:String]?
    let thumbnailURL: URL?
    let imagesURL: [URL]?
    let location: [String:String]?
    let price: Int?
    let formattedPrice: String?
    let difficulty: KTTripDifficulty?
    let date: String?
    let duration: [String:String]?
    
    init(id: String, name: [String:String], description: [String:String]?, thumbnailURL: URL?,
         imagesURL:[URL]?, location: [String:String]?, price: Int?, formattedPrice: String?, difficulty: KTTripDifficulty?, date: String?, duration: [String:String]?) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.location = location
        self.price = price
        self.formattedPrice = formattedPrice
        self.difficulty = difficulty
        self.date = date
        self.duration = duration
        self.imagesURL = imagesURL
    }
    
    
    
    init(trip: KTTrip) {
        self.id = trip.id
        self.name = trip.name
        self.description = trip.description
        self.thumbnailURL = URL(string: trip.thumbnail ?? "")
        self.location = trip.location
        self.price = trip.price
        self.formattedPrice = trip.price?.kztFormatted
        self.difficulty = .init(rawValue: trip.difficulty ?? "")
        self.date = trip.date
        self.duration = trip.duration
        self.imagesURL = trip.images?.compactMap{ URL(string: $0) }
    }
}
