//
//  TextureLoading.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

protocol TextureLoading: AnyObject {
    var device: MTLDevice { get }
    func loadTexture(texture: MDLTexture, name: String) -> MTLTexture?
    func loadTexture(name: String) -> MTLTexture?
    func clearCache()
}
