//
//  Model.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit
import Kase3DCore

@MainActor
final class Model: Transformable {
    var transform: Transform = .init()
    var meshes: [Mesh] = []
    var name: String = "Untitled"
    var tiling: UInt32 = 1
    
    init() { }
    
    init(assetURL: URL) {
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(
            url: assetURL,
            vertexDescriptor: .defaultLayout,
            bufferAllocator: allocator
        )
        
        asset.loadTextures()
        
        do {
            let (mdlMeshes, mtkMeshes) = try MTKMesh.newMeshes(
                asset: asset,
                device: Renderer.device
            )
            
            let loadedMeshes = zip(mdlMeshes, mtkMeshes).compactMap {
                Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
            }
            
            guard loadedMeshes.count == mdlMeshes.count else {
                meshes = []
                name = "Untitled"
                return
            }
            meshes = loadedMeshes
            name = assetURL.lastPathComponent
        } catch {
            let kaseError = ErrorManager.shared.map(error)
            ErrorManager.shared.present(kaseError)
        }
    }
    
    func setTexture(name: String, type: TextureIndices) {
        if let texture = TextureController.loadTexture(name: name) {
            switch type {
            case BaseColor:
                guard !meshes.indices.isEmpty, !meshes[0].submeshes.indices.isEmpty else { return }
                meshes[0].submeshes[0].textures.baseColor = texture
            default:
                break
            }
        }
    }
    
    func render(
        encoder: MTLRenderCommandEncoder,
        uniforms vertex: Uniforms,
        params fragment: Params
    ) {
        var uniforms = vertex
        var params = fragment
        params.tiling = tiling
        uniforms.modelMatrix = transform.modelMatrix
        uniforms.normalMatrix = transform.modelMatrix.upperLeft
        
        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index
        )
        
        encoder.setFragmentBytes(
            &params,
            length: MemoryLayout<Params>.stride,
            index: ParamsBuffer.index
        )
        
        for mesh in meshes {
            for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                encoder.setVertexBuffer(
                    vertexBuffer,
                    offset: 0,
                    index: index
                )
            }
            
            for submesh in mesh.submeshes {
                encoder.setFragmentTexture(
                    submesh.textures.baseColor,
                    index: BaseColor.index
                )
                
                encoder.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer,
                    indexBufferOffset: submesh.indexBufferOffset
                )
            }
        }
    }
}

