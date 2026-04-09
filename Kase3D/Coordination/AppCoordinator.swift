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
    let uiStore: UIStore
    var appStore: ApplicationStore
    
    init() {
        sceneManager = SceneManager()
        recentsManager = RecentFilesManager()
        uiStore = UIStore(sceneManager: sceneManager)
        appStore = ApplicationStore()
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
    
    func startAccessing(bookmark: RecentFileBookmark, completion: (URL) -> Void) {
        recentsManager.startAccessing(bookmark: bookmark, completion)
    }
    
    func addRecentFile(_ url: URL) {
        recentsManager.addRecentFile(url)
    }
    
    func clearRecents() {
        recentsManager.clearRecents()
    }
    
    func deselectPanel() {
        uiStore.panelCoordinator.deselect()
    }
}

@Observable
@MainActor
final class ApplicationStore {
    var isFileImporterPresented: Bool = false
}
