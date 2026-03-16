//
//  MeshLoading.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

/// @mockable
protocol MeshLoading: AnyObject {
    var device: any MTLDevice { get }
    func loadMeshes(from assetURL: URL, textureLoader: TextureLoading) throws -> [Mesh]
}
