//
//  EditorView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 09..
//

import SwiftUI

struct EditorView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        ZStack {
            MetalView()
            
            SideButtonColumnView {
                VStack {
                    ForEach(appCoordinator.uiStore.panelRegistry.panels, id: \.button) { panel in
                        SideButtonExpandingView(isOn: appCoordinator.uiStore.panelCoordinator.binding(for: panel.button)) {
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
                        openWindow(id: WindowKeys.welcome.rawValue)
                        dismissWindow(id: WindowKeys.editor.rawValue)
                        appCoordinator.unloadModel()
                    }
                }
            }
        }
    }
}
