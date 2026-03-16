//
//  MeshService.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

final class MeshService: MeshLoading {
    var device: any MTLDevice
    
    init(device: any MTLDevice) {
        self.device = device
    }
    
    func loadMeshes(from assetURL: URL, textureLoader: any TextureLoading) throws -> [Mesh] {
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(
            url: assetURL,
            vertexDescriptor: .defaultLayout,
            bufferAllocator: allocator
        )
        
        asset.loadTextures()
        
        let (mdlMeshes, mtkMeshes) = try MTKMesh.newMeshes(
            asset: asset,
            device: device
        )
        
        let loadedMeshes = zip(mdlMeshes, mtkMeshes).compactMap {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1, textureLoader: textureLoader)
        }
        
        guard loadedMeshes.count == mdlMeshes.count else {
            return []
        }
        
        return loadedMeshes
    }
}
