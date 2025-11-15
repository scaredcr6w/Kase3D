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
        self.library = library
        
        metalView.device = device
        self.model = Triangle(device: device)
        
        guard let pipelineState = Self.createPipelineState(
            device: device,
            library: library,
            metalView: metalView,
            model: model
        ) else { return nil }
        
        self.pipelineState = pipelineState
        
        super.init()
        
        self.setupUniforms(for: metalView)
        self.setupMetalView(metalView)
        metalView.delegate = self
    }
    
    private static func createPipelineState(
        device: MTLDevice,
        library: MTLLibrary,
        metalView: MTKView,
        model: Drawable
    ) -> MTLRenderPipelineState? {
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = model.vertexDescriptor
        
        do {
            return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func setupUniforms(for metalView: MTKView) {
        uniforms.viewMatrix = Matrix.viewMatrix(x: 0, y: 0, z: -3)
        uniforms.projectionMatrix = Matrix.projectionMatrix(aspectRatio: Float((metalView.bounds.width / metalView.bounds.height)))
    }
    
    private func setupMetalView(_ metalView: MTKView) {
        metalView.clearColor = MTLClearColor(
            red: 0.1,
            green: 0.1,
            blue: 0.1,
            alpha: 1.0
        )
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        uniforms.projectionMatrix = Matrix.projectionMatrix(
            aspectRatio: Float(size.width / size.height)
        )
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = Self.createRenderEncoder(commandBuffer: commandBuffer, descriptor: renderPassDescriptor) else {
            return
        }
        
        self.encodeRenderCommands(renderEncoder: renderEncoder, view: view)
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    private static func createRenderEncoder(
        commandBuffer: MTLCommandBuffer,
        descriptor: MTLRenderPassDescriptor
    ) -> MTLRenderCommandEncoder? {
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].storeAction = .store
        
        return commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
    }
    
    private func encodeRenderCommands(renderEncoder: MTLRenderCommandEncoder, view: MTKView) {
        renderEncoder.setRenderPipelineState(pipelineState)
        
        updateModelTransform()
        renderEncoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.size,
            index: 11
        )
        
        model.render(encoder: renderEncoder)
    }
    
    private func updateModelTransform() {
        model.position.y = -0.6
        uniforms.modelMatrix = model.transform.modelMatrix
    }
}
