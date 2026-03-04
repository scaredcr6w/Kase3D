//
//  ModelScene.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

struct ModelScene {
    var models: [Model] = []
    var gridPlane: Plane
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    
    @MainActor
    init() {
        gridPlane = Plane(size: 100)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
}
