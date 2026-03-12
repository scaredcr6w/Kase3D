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
    @State private var toggleStates: [SideButton: Bool] = [:]
    
    var body: some View {
        ZStack {
            ZStack {
                MetalView()
                    .opacity(sceneManager.hasLoadedAnyModel ? 1 : 0)
                
                SideButtonColumnView {
                    VStack {
                        ForEach(SideButton.allCases, id: \.hashValue) { button in
                            Toggle(button.rawValue, systemImage: button.symbol, isOn: binding(for: button))
                                .toggleStyle(GlassToggleStyle())
                            
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
    }
    
    private func binding(for button: SideButton) -> Binding<Bool> {
        Binding(
            get: { toggleStates[button] ?? false },
            set: { toggleStates[button] = $0 }
        )
    }
}

#Preview {
    ContentView()
}
