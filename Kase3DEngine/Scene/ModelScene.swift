//
//  ModelScene.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

public struct ModelScene {
    var models: [Model] = []
    var gridPlane: Plane
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    
    init(renderContext: RenderContext) {
        gridPlane = Plane(size: 100, renderContext: renderContext)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        camera.update(deltaTime: deltaTime, inputProviding: inputProviding)
    }
}
