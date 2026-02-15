//
//  Mesh.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

struct Mesh {
    var vertexBuffers: [MTLBuffer]
    var submeshes: [Submesh]
    
    @MainActor
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) throws {
        var vertexBuffers: [MTLBuffer] = []
        
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffers.append(mtkMeshBuffer.buffer)
        }
        
        self.vertexBuffers = vertexBuffers
        
        guard let subMeshes = mdlMesh.submeshes else { throw MeshError.failedToLoad }
        
        var builtSubmeshes: [Submesh] = []
        builtSubmeshes.reserveCapacity(mtkMesh.submeshes.count)
        
        for (mdlAny, mtkSub) in zip(subMeshes, mtkMesh.submeshes) {
            guard let mdlSubmesh = mdlAny as? MDLSubmesh else {
                throw MeshError.failedToLoad
            }
            let submesh = Submesh(mdlSubmesh: mdlSubmesh, mtkSubmesh: mtkSub)
            builtSubmeshes.append(submesh)
        }
        
        self.submeshes = builtSubmeshes
    }
}
