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
    @Environment(AppCoordinator.self) private var appCoordinator
    
    var body: some View {
        ZStack {
            ZStack {
                MetalView()
                    .opacity(appCoordinator.sceneManager.hasLoadedAnyModel ? 1 : 0)
                
                SideButtonColumnView {
                    VStack {
                        ForEach(appCoordinator.panelRegistry.panels, id: \.button) { panel in
                            SideButtonExpandingView(isOn: appCoordinator.panelCoordinator.binding(for: panel.button)) {
                                Image(systemName: panel.button.symbol)
                            } contentLabel: {
                                Text(panel.button.name)
                            } action: {
                                panel.content()
                            }

                        }
                        
                        SideButtonStaticView {
                            Image(systemName: "xmark")
                        } contentLabel: {
                            Text("Close Model")
                        } action: {
                            appCoordinator.panelCoordinator.deselect()
                            appCoordinator.unloadModel()
                        }

                    }
                }
                .opacity(appCoordinator.sceneManager.hasLoadedAnyModel ? 1 : 0)
            }
            WelcomeView()
                .opacity(appCoordinator.sceneManager.hasLoadedAnyModel ? 0 : 1)
                .allowsHitTesting(!appCoordinator.sceneManager.hasLoadedAnyModel)
        }
        .overlay {
            if let error = ErrorManager.shared.current {
                ErrorAlert(message: error.message, retry: error.retry) {
                    ErrorManager.shared.dismiss()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

