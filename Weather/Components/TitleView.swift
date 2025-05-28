//
//  TitleView.swift
//  Weather
//
//  Created by Greg Patrick on 4/6/25.
//

import SwiftUI

struct TitleView: View {
    let text: String
    
    var color: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Group {
                Text(text)
                    .font(.body)
                    .foregroundStyle(color)
                    .bold()
                
                Divider()
                    .frame(height: 1)
                    .background(color)
            }
            .baseShadow()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    TitleView(text: "Hourly Forecast")
}
