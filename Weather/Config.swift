//
//  Config.swift
//  Weather
//
//  Created by Greg Patrick on 7/3/22.
//

import UIKit

class Config {
    static let shared = Config()
    
    var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
