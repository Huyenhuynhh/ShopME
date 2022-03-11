//
//  RecentOrder.swift
//  ShopME
//
//  Created by Huyen on 04/03/2022.
//

import Foundation

struct RecentOrder {
    let quantity: Int
    let totalCost: Double
    let date: Date
    
    func getDateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
