//
//  Shape.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation
import MetalKit

protocol Shape: Drawable {
    var vertices: [Vertex] { get set }
    var indices: [UInt32] { get set }
    var device: MTLDevice { get }
    
    func updateBuffers()
}

extension Shape {
    func updateBuffers() {
        vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        if !indices.isEmpty {
            indexBuffer = device.makeBuffer(
                bytes: indices,
                length: indices.count * MemoryLayout<UInt32>.size,
                options: []
            )
        }
    }
    
    var indexCount: Int {
        indices.count
    }
    
    var vertexDescriptor: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = 0
        descriptor.attributes[0].bufferIndex = 0
        
        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        descriptor.layouts[0].stepRate = 1
        descriptor.layouts[0].stepFunction = .perVertex
        
        return descriptor
    }
}
