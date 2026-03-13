//
//  MetalRenderContext.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import MetalKit
import Kase3DCore

final class MetalRenderContext: RenderContext {
    let device: any MTLDevice
    let commandQueue: any MTLCommandQueue
    let library: any MTLLibrary
    
    let textureService: any TextureLoading
    let meshService: any MeshLoading
    
    init?(metalView: MTKView, bundle: Bundle = Bundle(for: MetalRenderContext.self)) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = try? device.makeDefaultLibrary(bundle: bundle) else {
            ErrorManager.shared.present(RendererError.failedToReachGPU)
            return nil
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.library = library
        
        self.textureService = TextureService(device: device)
        self.meshService = MeshService(device: device)
    }
}
