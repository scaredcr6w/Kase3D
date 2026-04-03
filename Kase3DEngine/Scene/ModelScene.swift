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
    var xAxisLine: AxisLine!
    var yAxisLine: AxisLine!
    var zAxisLine: AxisLine!
    var axisLineProperties: DirectionLineProperties
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    let renderContext: RenderContext
    
    private let geometrySize: Float = 100
    
    init(renderContext: RenderContext) {
        self.renderContext = renderContext
        
        gridPlane = Plane(size: geometrySize, renderContext: renderContext)
        axisLineProperties = DirectionLineProperties()
        
        axisLines(size: geometrySize, properties: axisLineProperties)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        camera.update(deltaTime: deltaTime, inputProviding: inputProviding)
        
        axisLineProperties.lineThickness = max(
            camera.distance * 0.001,
            axisLineProperties.minimumLineThickness
        )
        axisLines(size: geometrySize, properties: axisLineProperties)
    }
    
    private mutating func axisLines(size: Float, properties: DirectionLineProperties) {
        xAxisLine = AxisLine(
            extent: [size, 0, 0],
            properties: properties,
            renderContext: renderContext
        )
        yAxisLine = AxisLine(
            extent: [0, size, 0],
            properties: properties,
            renderContext: renderContext
        )
        zAxisLine = AxisLine(
            extent: [0, 0, size],
            properties: properties,
            renderContext: renderContext
        )
        
        xAxisLine.position.x = (size / 2) + (properties.lineThickness / 2)
        yAxisLine.position.y = (size / 2) - (properties.lineThickness / 2)
        zAxisLine.position.z = (size / 2) + (properties.lineThickness / 2)
    }
}
