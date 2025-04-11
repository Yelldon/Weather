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
    var appError: Api.AppError?
    var networkError: Bool = false
}

extension ErrorState {
    func setAppError(_ error: Api.AppError) {
        appError = error
    }
    
    func resetAppErrors() {
        appError = nil
        networkError = false
    }
}
