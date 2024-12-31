//
//  Item.swift
//  StreetsSanFranciscoFilming
//
//  Created by Ray Dolber on 12/30/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
