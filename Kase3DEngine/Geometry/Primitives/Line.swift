//
//  Line.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 21..
//

import MetalKit
import Kase3DCore

final class Line: Transformable {
    var transform: Transform = .init()
    var mesh: MTKMesh!
    
    init(extent: float3, renderContext: RenderContext) {
        transform.scale = 1
        
        var modifiedExtent = extent
        modifiedExtent.replace(with: 0.02, where: extent .== 0)
        buildMesh(extent: modifiedExtent, renderContext: renderContext)
    }
    
    private func buildMesh(extent: float3, renderContext: RenderContext) {
        let allocator = MTKMeshBufferAllocator(device: renderContext.device)
        
        let mdlMesh = MDLMesh(
            boxWithExtent: extent,
            segments: [0, 0, 1],
            inwardNormals: false,
            geometryType: .triangles,
            allocator: allocator
        )
        
        mdlMesh.vertexDescriptor = .simpleLayout
        
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: renderContext.device)
        } catch {
            fatalError("\(MeshError.failedToLoad): \(error.localizedDescription)")
        }
    }
    
    func set(position: float3) {
        transform.position = position
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
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset
            )
        }
    }
}
