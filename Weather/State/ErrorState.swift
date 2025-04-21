//
//  ErrorState.swift
//  Weather
//
//  Created by Greg Patrick on 4/10/25.
//

import Foundation
import Observation

@Observable
class ErrorState {
    var appError: WeatherAPI.AppError?
}

extension ErrorState {
    func setAppError(_ error: WeatherAPI.AppError) {
        appError = error
    }
    
    func resetAppErrors() {
        appError = nil
    }
}
