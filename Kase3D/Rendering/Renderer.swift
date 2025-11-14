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
        
        // pipeline state object
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
        
        uniforms.viewMatrix = float4x4(
            [            1,             0,             0, 0],
            [            0,             1,             0, 0],
            [            0,             0,             1, 0],
            [            0,             0,            -3, 1]
        )
        
        metalView.clearColor = MTLClearColor(
            red: 0.1,
            green: 0.1,
            blue: 0.1,
            alpha: 1.0
        )
        
        metalView.delegate = self
    }
    
    func createProjectionMatrix(aspectRatio: Float) -> float4x4 {
        let fov = Float.pi / 2
        let near: Float = 0.1
        let far: Float = 100.0
        
        let f = 1.0 / tan(fov / 2.0)
        
        var matrix = float4x4()
        matrix[0, 0] = f / aspectRatio
        matrix[1, 1] = f
        matrix[2, 2] = (far + near) / (near - far)
        matrix[2, 3] = -1.0
        matrix[3, 2] = (2 * far * near) / (near - far)
        
        return matrix
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
        
        let projectionMatrix = createProjectionMatrix(aspectRatio: Float((view.bounds.width / view.bounds.height)))
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
