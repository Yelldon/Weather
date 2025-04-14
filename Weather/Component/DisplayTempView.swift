//
//  DisplayTempView.swift
//  Weather
//
//  Created by Greg Patrick on 2/4/22.
//

import SwiftUI

struct DisplayTempView: View {
    var temp: String
    
    var body: some View {
        Text(tempText)
    }
}

// MARK: Properties
extension DisplayTempView {
    var tempText: String {
        "\(temp)°"
    }
}

#Preview {
    DisplayTempView(temp: "72")
}
