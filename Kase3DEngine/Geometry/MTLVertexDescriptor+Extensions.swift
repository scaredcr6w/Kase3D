//
//  MTLVertexDescriptor+Extensions.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

import MetalKit

extension MDLVertexDescriptor {
    static var defaultLayout: MDLVertexDescriptor {
        let descriptor = MDLVertexDescriptor()
        var offset = 0
        descriptor.attributes[Position.index] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: offset,
            bufferIndex: VertexBuffer.index
        )
        offset += MemoryLayout<float3>.stride
        
        descriptor.attributes[Normal.index] = MDLVertexAttribute(
            name: MDLVertexAttributeNormal,
            format: .float3,
            offset: offset,
            bufferIndex: VertexBuffer.index
        )
        offset += MemoryLayout<float3>.stride
        descriptor.layouts[VertexBuffer.index] = MDLVertexBufferLayout(stride: offset)
        
        descriptor.attributes[UV.index] = MDLVertexAttribute(
            name: MDLVertexAttributeTextureCoordinate,
            format: .float2,
            offset: offset,
            bufferIndex: UVBuffer.index
        )
        descriptor.layouts[UVBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float2>.stride)
        
        return descriptor
    }
    
    static var simpleLayout: MDLVertexDescriptor {
        let descriptor = MDLVertexDescriptor()
        descriptor.attributes[Position.index] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: VertexBuffer.index
        )
        
        descriptor.layouts[VertexBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float3>.stride)
        
        return descriptor
    }
}

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.defaultLayout)
    }
    
    static var simpleLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.simpleLayout)
    }
}

extension Attributes {
    var index: Int {
        Int(self.rawValue)
    }
}

extension BufferIndices {
    var index: Int {
        Int(self.rawValue)
    }
}

extension TextureIndices {
    var index: Int {
        Int(self.rawValue)
    }
}
