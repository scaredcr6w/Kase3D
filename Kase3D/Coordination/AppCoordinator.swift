//
//  AppCoordinator.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import Foundation
import Kase3DEngine

@Observable
@MainActor
final class AppCoordinator {
    let sceneManager: SceneManager
    let recentsManager: RecentFilesManager
    let panelRegistry: PanelRegistry
    let panelCoordinator: SideButtonPanelCoordinator
    
    init() {
        sceneManager = SceneManager()
        recentsManager = RecentFilesManager()
        panelCoordinator = SideButtonPanelCoordinator()
        panelRegistry = PanelRegistry()
        
        panelRegistry.register(MeshInspectorPanel(sceneManager: sceneManager))
        panelRegistry.register(LightInspectorPanel(sceneManager: sceneManager))
    }
    
    func loadModel(from url: URL) {
        sceneManager.loadModel(from: url)
    }
    
    func unloadModel() {
        sceneManager.unload()
    }
    
    func openRecent(_ bookmark: RecentFileBookmark) {
        recentsManager.startAccessing(bookmark: bookmark, sceneManager.loadModel(from:))
    }
    
    func addRecentFile(_ url: URL) {
        recentsManager.addRecentFile(url)
    }
    
    func clearRecents() {
        recentsManager.clearRecents()
    }
}
