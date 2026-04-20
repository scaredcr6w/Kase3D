//
//  AppCoordinator+SceneManager.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 16..
//

import Foundation
import Kase3DEngine

extension AppCoordinator {
    func loadModel(from url: URL) {
        sceneManager.loadModel(from: url)
    }
    
    func unloadModel() {
        sceneManager.unload()
    }
}
