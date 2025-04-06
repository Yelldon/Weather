//
//  Helpers.swift
//  Weather
//
//  Created by Greg Patrick on 7/4/22.
//

import Foundation

func convertCToF(_ temp: Double) -> Int {
    let far = (temp * 1.8) + 32
    return Int(far.rounded())
}

func time(_ date: String) -> String? {
    let formatter = DateFormatter()

    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let stringDate = formatter.date(from: date)
    
    if let formattedDate = stringDate {
        if formatter.calendar.isDateInToday(formattedDate) {
            formatter.dateStyle = .none
        } else {
            formatter.dateStyle = .short
        }
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: formattedDate)
    }
    
    return nil
}

func hour(_ date: String) -> String? {
    let formatter = DateFormatter()

    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let stringDate = formatter.date(from: date)
    
    if let formattedDate = stringDate {
        formatter.dateFormat = "h a"
        return formatter.string(from: formattedDate)
    }
    
    return nil
}

func degreeText(_ string: String) -> String {
    "\(string)°"
}
