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
                        SideButtonExpandingView(isOn: buttonViewModel.binding(for: .mesh)) {
                            Image(systemName: SideButton.mesh.symbol)
                        } contentLabel: {
                            Text(SideButton.mesh.name)
                        } action: {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    //
                                }
                            }
                        }
                        
                        SideButtonExpandingView(isOn: buttonViewModel.binding(for: .lighting)) {
                            Image(systemName: SideButton.lighting.symbol)
                        } contentLabel: {
                            Text(SideButton.lighting.name)
                        } action: {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    //
                                }
                            }
                        }
                        
                        SideButtonStaticView {
                            Image(systemName: SideButton.closeModel.symbol)
                        } contentLabel: {
                            Text(SideButton.closeModel.name)
                        } action: {
                            buttonViewModel.selected = nil
                            sceneManager.unload()
                        }

                    }
                }
                .opacity(sceneManager.hasLoadedAnyModel ? 1 : 0)
            }
            WelcomeView()
                .opacity(sceneManager.hasLoadedAnyModel ? 0 : 1)
                .allowsTightening(!sceneManager.hasLoadedAnyModel)
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

