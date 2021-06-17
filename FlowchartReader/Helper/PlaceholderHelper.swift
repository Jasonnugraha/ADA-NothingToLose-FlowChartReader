//
//  PlaceholderHelper.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 13/06/21.
//

import Foundation

class Helper {
    func dateFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM, yyyy"
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        dateFormater.timeZone = TimeZone.current
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
    }
}
