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
    var xAxisLine: AxisLine
    var yAxisLine: AxisLine
    var zAxisLine: AxisLine
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    
    init(renderContext: RenderContext) {
        let size: Float = 100
        gridPlane = Plane(size: size, renderContext: renderContext)
        
        xAxisLine = AxisLine(extent: [size, 0, 0], renderContext: renderContext)
        xAxisLine.position.x = size / 2
        
        yAxisLine = AxisLine(extent: [0, size, 0], renderContext: renderContext)
        yAxisLine.position.y = size / 2
        
        zAxisLine = AxisLine(extent: [0, 0, size], renderContext: renderContext)
        zAxisLine.position.z = size / 2
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        camera.update(deltaTime: deltaTime, inputProviding: inputProviding)
    }
}
