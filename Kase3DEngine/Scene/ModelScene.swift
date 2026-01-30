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
    
    init() {
        camera.distance = 2.5
        camera.transform = Transform(
            position: [-1.18, 1.57, -1.28],
            rotation: [-0.73, 13.3, 0.0]
        )
        
        gridPlane = Plane(size: camera.far * 2, divisions: 50)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
}
