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
}
