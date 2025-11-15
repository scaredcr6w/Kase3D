//
//  Renderer.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation
import MetalKit

@MainActor
final class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let library: MTLLibrary
    let pipelineState: MTLRenderPipelineState
    
    var model: Drawable
    var uniforms = Uniforms()
    
    init?(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        self.device = device
        self.commandQueue = commandQueue
        metalView.device = device
        
        self.model = Triangle(device: device)
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        self.library = library
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = model.vertexDescriptor
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        super.init()
        
        uniforms.viewMatrix = Matrix.viewMatrix(x: 0, y: 0, z: -3)
        
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
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }

        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store

        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            commandBuffer.commit()
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        let projectionMatrix = Matrix.projectionMatrix(aspectRatio: Float((view.bounds.width / view.bounds.height)))
        uniforms.projectionMatrix = projectionMatrix

        model.position.y = -0.6
        uniforms.modelMatrix = model.transform.modelMatrix
        
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 11)
        
        model.render(encoder: renderEncoder)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
