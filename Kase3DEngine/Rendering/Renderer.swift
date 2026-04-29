//
//  Renderer.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

import MetalKit
import Kase3DCore

@MainActor
final class Renderer: NSObject, SceneRendering {
    let renderContext: any RenderContext
    var pipelineState: MTLRenderPipelineState!
    var gridPipelineState: MTLRenderPipelineState!
    var xAxisLinePipelineState: MTLRenderPipelineState!
    var yAxisLinePipelineState: MTLRenderPipelineState!
    var zAxisLinePipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    var uniforms = Uniforms()
    var params = Params()
    
    init?(metalView: MTKView, renderContext: RenderContext) {
        self.renderContext = renderContext
        metalView.device = renderContext.device
        super.init()
        buildPipelineState(metalView: metalView)
        buildGridPipelineState(metalView: metalView)
        buildDepthStencilState()
        buildXAxisLineState(metalView: metalView)
        buildYAxisLineState(metalView: metalView)
        buildZAxisLineState(metalView: metalView)
        metalView.clearColor = MTLClearColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
        metalView.depthStencilPixelFormat = .depth32Float
    }
    
    private func buildPipelineState(metalView: MTKView) {
        let vertexFunction = renderContext.library.makeFunction(name: "vertex_main")
        let fragmentFunction = renderContext.library.makeFunction(name: "fragment_main")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
        
        do {
            self.pipelineState = try renderContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildGridPipelineState(metalView: MTKView) {
        let vertexFunction = renderContext.library.makeFunction(name: "vertex_simple")
        let fragmentFunction = renderContext.library.makeFunction(name: "fragment_grid_plane")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.simpleLayout
        
        do {
            self.gridPipelineState = try renderContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildXAxisLineState(metalView: MTKView) {
        let vertexFunction = renderContext.library.makeFunction(name: "vertex_simple")
        let fragmentFunction = renderContext.library.makeFunction(name: "fragment_x_axis")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.simpleLayout
        
        do {
            self.xAxisLinePipelineState = try renderContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildYAxisLineState(metalView: MTKView) {
        let vertexFunction = renderContext.library.makeFunction(name: "vertex_simple")
        let fragmentFunction = renderContext.library.makeFunction(name: "fragment_y_axis")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.simpleLayout
        
        do {
            self.yAxisLinePipelineState = try renderContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildZAxisLineState(metalView: MTKView) {
        let vertexFunction = renderContext.library.makeFunction(name: "vertex_simple")
        let fragmentFunction = renderContext.library.makeFunction(name: "fragment_z_axis")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.simpleLayout
        
        do {
            self.zAxisLinePipelineState = try renderContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildDepthStencilState() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        self.depthStencilState = renderContext.device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension Renderer {
    func updateUniforms(scene: ModelScene) {
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.cameraPosition = scene.camera.position
    }
    
    func draw(scene: ModelScene, in view: MTKView) {
        guard let commandBuffer = renderContext.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        updateUniforms(scene: scene)
        
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(gridPipelineState)
        scene.gridPlane.render(encoder: renderEncoder, uniforms: uniforms)
        
        renderEncoder.setRenderPipelineState(xAxisLinePipelineState)
//        scene.xAxisLine.render(encoder: renderEncoder, uniforms: uniforms)
//        
//        renderEncoder.setRenderPipelineState(yAxisLinePipelineState)
//        scene.yAxisLine.render(encoder: renderEncoder, uniforms: uniforms)
//        
//        renderEncoder.setRenderPipelineState(zAxisLinePipelineState)
//        scene.zAxisLine.render(encoder: renderEncoder, uniforms: uniforms)
        scene.axisLines.render(encoder: renderEncoder, uniforms: uniforms)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(
            &lights,
            length: MemoryLayout<Light>.stride * lights.count,
            index: LightBuffer.index
        )
        
        for model in scene.models {
            model.render(
                encoder: renderEncoder,
                uniforms: uniforms,
                params: params
            )
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
