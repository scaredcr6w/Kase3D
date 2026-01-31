//
//  Plane.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 30..
//

import MetalKit

final class Plane: Transformable {
    var transform: Transform = .init()
    var mesh: MTKMesh!
    
    init(size: Float = 10) {
        self.transform.scale = 1
        buildMesh(size: size)
    }
    
    private func buildMesh(size: Float) {
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let mdlMesh = MDLMesh(
            planeWithExtent: [size, 0, size],
            segments: [UInt32(size / 2), UInt32(size / 2)],
            geometryType: .lines,
            allocator: allocator
        )
        
        mdlMesh.vertexDescriptor = .simpleLayout
        
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: Renderer.device)
        } catch {
            fatalError("\(MeshError.failedToLoad): \(error.localizedDescription)")
        }
    }
    
    func render(encoder: MTLRenderCommandEncoder, uniforms: Uniforms) {
        var uniforms = uniforms
        uniforms.modelMatrix = transform.modelMatrix
        
        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index
        )
        
        for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
            encoder.setVertexBuffer(
                vertexBuffer.buffer,
                offset: vertexBuffer.offset,
                index: index
            )
        }
        
        for submesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(
                type: .line,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset
            )
        }
    }
}
