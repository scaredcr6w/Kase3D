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
    
    func setPosition() {
        xAxisLine.set(position: [0.5 * size, 0, 0])
        yAxisLine.set(position: [0, 0.5 * size, 0])
        zAxisLine.set(position: [0, 0, 0.5 * size])
    }
    
    func render(encoder: any MTLRenderCommandEncoder, uniforms: Uniforms) {
        var color = float4(1, 0, 0, 1)
        setFragmentColor(&color, encoder: encoder)
        xAxisLine.render(encoder: encoder, uniforms: uniforms)
        
        color = float4(0, 1, 0, 1)
        setFragmentColor(&color, encoder: encoder)
        yAxisLine.render(encoder: encoder, uniforms: uniforms)
        
        color = float4(0, 0, 1, 1)
        setFragmentColor(&color, encoder: encoder)
        zAxisLine.render(encoder: encoder, uniforms: uniforms)
    }
    
    private func setFragmentColor(_ color: inout float4, encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(
            &color,
            length: MemoryLayout<float4>.stride,
            index: ColorBuffer.index
        )
    }
}
