//
//  DisplayTemp.swift
//  
//
//  Created by Greg Patrick on 2/4/22.
//

import SwiftUI

struct DisplayTemp: View {
    var temp: String
//    var size: Double
//    var isLoading = true
    
    var body: some View {
        Text(tempText)
//            .font(.system(size: size))
//            .redacted(reason: isLoading ? .placeholder : [])
    }
}

extension DisplayTemp {
    var tempText: String {
        "\(temp)°"
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
//        DisplayTemp(temp: "32", size: 56.0, isLoading: false)
        DisplayTemp(temp: "72")
    }
}
