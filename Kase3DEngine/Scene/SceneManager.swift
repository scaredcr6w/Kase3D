//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation

@Observable
public final class SceneManager {
    var modelScene: ModelScene?
    
    public init() { }
    
    public func loadModel(from assetURL: URL) {
        let model = Model(assetURL: assetURL)
        modelScene?.models.append(model)
    }
}
