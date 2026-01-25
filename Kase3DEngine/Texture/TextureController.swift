//
//  TextureController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

struct TextureController {
    static var textures: [String: MTLTexture] = [:]
    
    static func loadTexture(texture: MDLTexture, name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .generateMipmaps: true
        ]
        
        let texture = try? textureLoader.newTexture(
            texture: texture,
            options: textureLoaderOptions
        )
        textures[name] = texture
        
        return texture
    }
    
    static func loadTexture(name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let texture: MTLTexture?
        texture = try? textureLoader.newTexture(
            name: name,
            scaleFactor: 1,
            bundle: Bundle.main
        )
        
        if let texture {
            textures[name] = texture
            return texture
        }
        
        return nil
    }
}
