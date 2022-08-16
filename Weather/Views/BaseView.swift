//
//  BaseView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var state = AppState.shared
    
    var body: some View {
        TabView {
            VStack {
//                ScrollView {
//                    VStack {}
//                        .frame(
//                            maxWidth: .infinity,
//                            maxHeight: 0
//                        )
//                        .opacity(0)
                    
                    MainView()
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 0.1)
            }
//            .background(.blue)
            
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                debugPrint("** App became active **")
                state.location = LocationManager()
            } else if newPhase == .inactive {
                debugPrint("** App became inactive **")
            } else if newPhase == .background {
                debugPrint("** App entered background **")
            }
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
