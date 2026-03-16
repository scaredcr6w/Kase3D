//
//  TextureService.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

final class TextureService: TextureLoading {
    var device: any MTLDevice
    var textures: [String: MTLTexture] = [:]
    
    init(device: any MTLDevice) {
        self.device = device
    }
    
    func loadTexture(texture: MDLTexture, name: String) -> (any MTLTexture)? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: device)
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .generateMipmaps: true
        ]
        
        if let texture = try? textureLoader.newTexture(
            texture: texture,
            options: textureLoaderOptions
        ) {
            textures[name] = texture
            
            return texture
        }
        
        return nil
    }
    
    func loadTexture(name: String) -> (any MTLTexture)? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: device)
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
    
    func clearCache() {
        textures.removeAll()
    }
}
