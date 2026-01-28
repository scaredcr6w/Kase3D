//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation

@Observable
public final class SceneManager {
    var displayScene: DisplayScene?
    
    public init() { }
    
    public func loadModel(from assetURL: URL) {
        let model = Model(assetURL: assetURL)
        displayScene?.models.append(model)
    }
}
