//
//  Drawable.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation
import MetalKit

protocol Drawable: AnyObject, Transformable {
    var vertexBuffer: MTLBuffer? { get set }
    var indexBuffer: MTLBuffer? { get set }
    var indexCount: Int { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
    
    func render(encoder: MTLRenderCommandEncoder)
}

extension Drawable {
    func render(encoder: MTLRenderCommandEncoder) {
        guard let vertexBuffer else { return }
        
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        if let indexBuffer {
            encoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: indexCount,
                indexType: .uint32,
                indexBuffer: indexBuffer,
                indexBufferOffset: 0
            )
        } else {
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
        }
    }
    
    var vertexCount: Int {
        guard let vertexBuffer else { return 0 }
        return vertexBuffer.length / MemoryLayout<Vertex>.stride
    }
}
