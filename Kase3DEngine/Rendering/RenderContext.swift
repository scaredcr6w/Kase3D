//
//  RenderContext.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit

/// @mockable
protocol RenderContext: AnyObject {
    var device: MTLDevice { get }
    var commandQueue: MTLCommandQueue { get }
    var library: MTLLibrary { get }
}
