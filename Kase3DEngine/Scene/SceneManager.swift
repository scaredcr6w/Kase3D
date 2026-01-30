//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation

@Observable
public final class SceneManager {
    var modelScene: ModelScene!
    public var hasLoadedAnyModel: Bool = false
    
    public init() { }
    
    public func loadModel(from assetURL: URL) {
        guard modelScene != nil else { return }
        
        let model = Model(assetURL: assetURL)
        modelScene.models.append(model)
        hasLoadedAnyModel = true
    }
}
