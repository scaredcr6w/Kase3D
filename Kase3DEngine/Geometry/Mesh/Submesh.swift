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
    
    struct Textures {
        var baseColor: MTLTexture?
    }
    
    var textures: Textures
}

extension Submesh {
    @MainActor init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        textures = Textures(material: mdlSubmesh.material)
    }
}

private extension Submesh.Textures {
    @MainActor init(material: MDLMaterial?) {
        baseColor = material?.texture(type: .baseColor)
    }
}

private extension MDLMaterialProperty {
    var textureName: String {
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial {
    @MainActor func texture(type semantic: MDLMaterialSemantic) -> MTLTexture? {
        if let property = property(with: semantic),
           property.type == .texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return TextureController.loadTexture(
                texture: mdlTexture,
                name: property.textureName
            )
        }
        
        return nil
    }
}
