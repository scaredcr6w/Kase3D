//
//  Renderer.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation
import MetalKit

final class Renderer: NSObject, Sendable {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let library: MTLLibrary
    let pipelineState: MTLRenderPipelineState
    
    init?(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        self.device = device
        self.commandQueue = commandQueue
        metalView.device = device
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        self.library = library
        
        // pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        super.init()
        
        metalView.clearColor = MTLClearColor(
            red: 0.1,
            green: 0.1,
            blue: 0.1,
            alpha: 1.0
        )
        
        metalView.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }

        // Configure render pass (clear is handled by view.clearColor)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store

        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            commandBuffer.commit()
            return
        }

        // Set pipeline state; no vertex buffers yet (just a clear)
        renderEncoder.setRenderPipelineState(pipelineState)

        // End encoding and present
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
