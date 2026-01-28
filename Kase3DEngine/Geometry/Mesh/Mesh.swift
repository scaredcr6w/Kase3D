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
    
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) throws {
        var vertexBuffers: [MTLBuffer] = []
        
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffers.append(mtkMeshBuffer.buffer)
        }
        
        self.vertexBuffers = vertexBuffers
        
        guard let subMeshes = mdlMesh.submeshes else { throw MeshError.failedToLoad }
        
        submeshes = try zip(subMeshes, mtkMesh.submeshes).map { mesh in
            guard let mdlSubmesh = mesh.0 as? MDLSubmesh else {
                throw MeshError.failedToLoad
            }
            
            return Submesh(mdlSubmesh: mdlSubmesh, mtkSubmesh: mesh.1)
        }
    }
}
