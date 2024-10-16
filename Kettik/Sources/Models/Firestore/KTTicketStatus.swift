//
//  KTTicketStatus.swift
//  Kettik
//
//  Created by Tami on 03.06.2024.
//

import Foundation
import UIKit

struct TicketStatusInfo {
    let image: UIImage
    let textColor: UIColor
    let statusText: String
}

enum TicketStatus: String {
    case pending
    case invalid
    case purchased
    
    var info: TicketStatusInfo {
        switch self {
        case .pending:
            return TicketStatusInfo(image: KTImages.Element.pendingQR.image,
                                    textColor: .systemBlue,
                                    statusText: KTStrings.Ticket.pending)
        case .invalid:
            return TicketStatusInfo(image: KTImages.Element.invalidQR.image,
                                    textColor: .red,
                                    statusText: KTStrings.Ticket.invalid)
        case .purchased:
            return TicketStatusInfo(image: KTImages.Element.verifiedQR.image,
                                    textColor: .green,
                                    statusText: KTStrings.Ticket.purchased)
        }
    }
}
