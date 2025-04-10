//
//  SearchField.swift
//  Weather
//
//  Created by Greg Patrick on 4/9/25.
//

import SwiftUI

struct SearchField: View {
    var text: Binding<String>
    
    var body: some View {
        TextField(
            "",
            text: text,
            prompt: Text(LocalizedStringKey("SearchPlaceholder"))
                .foregroundStyle(Color.searchPlaceholder)
        )
        .textFieldStyle(BaseFieldStyle())
    }
}

#Preview {
    SearchField(text: Binding.constant("Test Text"))
}
