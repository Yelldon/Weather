//
//  View+Weather.swift
//  Weather
//
//  Created by Greg Patrick on 4/8/25.
//

import SwiftUI

extension View {
    @ViewBuilder func contentLoading(_ isLoading: Bool) -> some View {
        self
            .redacted(reason: isLoading ? .placeholder : [])
    }
    
    func whiteBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [.white, .gray.opacity(0.4)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .background(.white)
    }
    
    func baseShadow() -> some View {
        self
            .shadow(radius: 8)
    }
    
    func roundedCorners(_ radius: CGFloat = 8) -> some View {
        self
            .clipShape(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
            )
            .baseShadow()
    }
}
