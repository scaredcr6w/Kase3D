//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation
import Combine

@Observable
public final class SceneManager {
    var displayScene: DisplayScene!
    
    public init() { }
    
    public func loadModel(from assetURL: URL) {
        do {
            let model = try Model(assetURL: assetURL)
            displayScene.models.append(model)
        } catch {
            print(error.localizedDescription)
        }
    }
}
