//
//  ModelScene.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

struct ModelScene {
    var models: [Model] = []
    var gridPlane: Plane?
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    
    @MainActor
    init() {
        camera.distance = 20
        camera.transform = Transform(
            position: [0, 3, 0],
            rotation: [-0.78, 3.14, 0.0]
        )
        
        gridPlane = Plane(size: camera.far * 2)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
}
