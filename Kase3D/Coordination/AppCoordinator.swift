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
}
