//
//  KTTicketAdapter.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import Foundation

struct KTTicketAdapter {
    
    let id: String
    let tripId: String
    let name: String
    let formattedTotalPrice: String
    let count: Int
    let purchaseDate: Date
    let status: String
    
    init(id: String, tripId: String, name: String, formattedTotalPrice: String, count: Int, purchaseDate: Date, status: String) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.formattedTotalPrice = formattedTotalPrice
        self.count = count
        self.purchaseDate = purchaseDate
        self.status = status
    }
    
    init(ticket: KTTicket) {
        self.id = ticket.id
        self.tripId = ticket.tripId
        self.name = ticket.name
        self.formattedTotalPrice = ticket.totalPrice.kztFormatted
        self.count = ticket.count
        self.purchaseDate = ticket.purchaseDate
        self.status = ticket.status
    }
}
