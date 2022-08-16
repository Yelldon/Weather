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
