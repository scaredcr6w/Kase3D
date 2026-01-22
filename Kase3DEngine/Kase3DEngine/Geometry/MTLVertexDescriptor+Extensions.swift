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
        return descriptor
    }
}

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.defaultLayout)
    }
}
