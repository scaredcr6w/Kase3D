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
    var axisLines: AxisLines
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    let renderContext: RenderContext
    
    private let geometrySize: Float = 100
    
    init(renderContext: RenderContext) {
        self.renderContext = renderContext
        
        gridPlane = Plane(size: geometrySize * 2, renderContext: renderContext)
        axisLines = AxisLines(size: geometrySize, renderContext: renderContext)
        axisLines.setPosition()
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        camera.update(deltaTime: deltaTime, inputProviding: inputProviding)
    }
}
