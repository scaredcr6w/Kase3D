//
//  ContentView.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI
import Kase3DEngine
import Kase3DCore

struct ContentView: View {
    @Environment(SceneManager.self) private var sceneManager
    @State private var buttonViewModel = SideButtonViewModel()
    
    var body: some View {
        ZStack {
            ZStack {
                MetalView()
                    .opacity(sceneManager.hasLoadedAnyModel ? 1 : 0)
                
                SideButtonColumnView {
                    VStack {
                        ForEach(SideButton.allCases, id: \.hashValue) { button in
                            SideButtonView(isOn: buttonViewModel.binding(for: button)) {
                                Image(systemName: button.symbol)
                            } contentLabel: {
                                Text(button.rawValue)
                            } action: {
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        //
                                    }
                                }
                            }

                        }
                    }
                }
                .opacity(sceneManager.hasLoadedAnyModel ? 1 : 0)
            }
            WelcomeView()
                .opacity(sceneManager.hasLoadedAnyModel ? 0 : 1)
        }
        .overlay {
            if let error = ErrorManager.shared.current {
                ErrorAlert(message: error.message, retry: error.retry) {
                    ErrorManager.shared.dismiss()
                }
            }
        }
        .environment(buttonViewModel)
    }
}

#Preview {
    ContentView()
}

