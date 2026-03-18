//
//  UIStore.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 18..
//

import Foundation
import Kase3DEngine

@MainActor
final class UIStore {
    let panelRegistry: PanelRegistry
    let panelCoordinator: SideButtonPanelCoordinator
    
    init(sceneManager: SceneManager) {
        panelCoordinator = SideButtonPanelCoordinator()
        panelRegistry = PanelRegistry()
        
        panelRegistry.register(MeshInspectorPanel(sceneManager: sceneManager))
        panelRegistry.register(LightInspectorPanel(sceneManager: sceneManager))
    }
}
