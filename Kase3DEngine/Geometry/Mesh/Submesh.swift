//
//  Submesh.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

struct Submesh {
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
    let submeshProperties: SubmeshProperties
    
    struct Textures {
        var baseColor: MTLTexture?
    }
    
    var textures: Textures
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh, textureLoader: TextureLoading) {
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        textures = Textures(material: mdlSubmesh.material, textureLoader: textureLoader)
        submeshProperties = SubmeshProperties(submeshName: mdlSubmesh.material?.name ?? mdlSubmesh.name)
    }
}

private extension Submesh.Textures {
    init(material: MDLMaterial?, textureLoader: TextureLoading) {
        baseColor = material?.texture(type: .baseColor, textureLoader: textureLoader)
    }
}

private extension MDLMaterialProperty {
    var textureName: String {
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial {
    func texture(type semantic: MDLMaterialSemantic, textureLoader: TextureLoading) -> MTLTexture? {
        if let property = property(with: semantic),
           property.type == .texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return textureLoader.loadTexture(
                texture: mdlTexture,
                name: property.textureName
            )
        }
        
        return nil
    }
}
