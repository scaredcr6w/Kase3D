//
//  Mesh.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit
import Kase3DCore

public struct Mesh {
    var vertexBuffers: [MTLBuffer]
    var submeshes: [Submesh]
    
    init?(mdlMesh: MDLMesh, mtkMesh: MTKMesh, textureLoader: TextureLoading) {
        var vertexBuffers: [MTLBuffer] = []
        
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffers.append(mtkMeshBuffer.buffer)
        }
        
        self.vertexBuffers = vertexBuffers
        
        guard let subMeshes = mdlMesh.submeshes else {
            ErrorManager.shared.present(MeshError.failedToLoad)
            return nil
        }
        
        var builtSubmeshes: [Submesh] = []
        builtSubmeshes.reserveCapacity(mtkMesh.submeshes.count)
        
        for (mdlAny, mtkSub) in zip(subMeshes, mtkMesh.submeshes) {
            guard let mdlSubmesh = mdlAny as? MDLSubmesh else {
                ErrorManager.shared.present(MeshError.failedToLoad)
                return nil
            }
            let submesh = Submesh(mdlSubmesh: mdlSubmesh, mtkSubmesh: mtkSub, textureLoader: textureLoader)
            builtSubmeshes.append(submesh)
        }
        
        self.submeshes = builtSubmeshes
    }
}
