//
//  AxisLines.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 04. 29..
//

import MetalKit

final class AxisLines: PrimitiveBundle {    
    var xAxisLine: Line
    var yAxisLine: Line
    var zAxisLine: Line
    var size: Float
    
    init(size: Float, renderContext: RenderContext) {
        self.size = size
        
        xAxisLine = Line(
            extent: [size, 0, 0],
            renderContext: renderContext
        )
        yAxisLine = Line(
            extent: [0, size, 0],
            renderContext: renderContext
        )
        zAxisLine = Line(
            extent: [0, 0, size],
            renderContext: renderContext
        )
    }
    
    func update(thickness: Float) {
        let scaledThickness = thickness / 10
        xAxisLine.update(thickness: scaledThickness, position: [0.5 * size * xAxisLine.scale, 0, 0])
        yAxisLine.update(thickness: scaledThickness, position: [0, 0.5 * size * yAxisLine.scale, 0])
        zAxisLine.update(thickness: scaledThickness, position: [0, 0, 0.5 * size * zAxisLine.scale])
    }
    
    func render(encoder: any MTLRenderCommandEncoder, uniforms: Uniforms) {
        xAxisLine.render(encoder: encoder, uniforms: uniforms)
        yAxisLine.render(encoder: encoder, uniforms: uniforms)
        zAxisLine.render(encoder: encoder, uniforms: uniforms)
    }
}
