//
//  Triangle.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation
import MetalKit

final class Triangle: Shape {
    var transform: Transform
    
    var vertices: [Vertex] = []
    var indices: [UInt32] = []
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var device: MTLDevice
    
    init(device: MTLDevice) {
        self.device = device
        self.transform = Transform()
        setupGeometry()
        updateBuffers()
    }
    
    func setupGeometry() {
        vertices = [
            Vertex(position: SIMD3<Float>(0.0, 0.5, 0.0)),
            Vertex(position: SIMD3<Float>(-0.5, -0.5, 0.0)),
            Vertex(position: SIMD3<Float>(0.5, -0.5, 0.0))
        ]
        
        indices = [0, 1, 2]
    }
}
