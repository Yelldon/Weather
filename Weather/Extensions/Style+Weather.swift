//
//  Style+Weather.swift
//  Weather
//
//  Created by Greg Patrick on 4/9/25.
//

import SwiftUI

struct BaseFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(.ultraThinMaterial)
            .foregroundStyle(Color.white)
            .clipShape(
                Capsule()
            )
    }
}
