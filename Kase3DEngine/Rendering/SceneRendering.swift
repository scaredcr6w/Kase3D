//
//  SceneRendering.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

public protocol SceneRendering: AnyObject {
    func draw(scene: ModelScene, in view: MTKView)
}
