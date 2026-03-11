//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation

@Observable
@MainActor
public final class SceneManager {
    var modelScene: ModelScene!
    
    public init() { }
    
    public var hasLoadedAnyModel: Bool {
        guard modelScene != nil else { return false }
        return !modelScene.models.isEmpty
    }
    
    public func loadModel(from assetURL: URL) {
        guard modelScene != nil else { return }
        
        let model = Model(assetURL: assetURL)
        modelScene.models.append(model)
    }
    
    public func unload() {
        guard modelScene != nil else { return }
        modelScene.models.removeAll()
    }
}
