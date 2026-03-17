//
//  LigthInspectorPanel.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import SwiftUI
import Kase3DEngine

@MainActor
final class LigthInspectorPanel: PanelProvider {
    let button: SideButton = .lighting
    private let sceneManager: SceneManager
    
    init(sceneManager: SceneManager) {
        self.sceneManager = sceneManager
    }
    
    func content() -> AnyView {
        AnyView(LightInspectorView(sceneManager: sceneManager))
    }
}
