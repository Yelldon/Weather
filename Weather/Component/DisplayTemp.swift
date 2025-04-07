//
//  DisplayTemp.swift
//  
//
//  Created by Greg Patrick on 2/4/22.
//

import SwiftUI

struct DisplayTemp: View {
    var temp: String
//    var isLoading = true
    
    var body: some View {
        Text(tempText)
//            .redacted(reason: isLoading ? .placeholder : [])
    }
}

extension DisplayTemp {
    var tempText: String {
        "\(temp)°"
    }
}

#Preview {
    DisplayTemp(temp: "72")
}
