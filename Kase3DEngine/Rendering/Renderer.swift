//
//  Renderer.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

import MetalKit

@MainActor
public final class Renderer: NSObject {
    static var device: MTLDevice!
    var commandQueue: MTLCommandQueue
    var library: MTLLibrary
    var pipelineState: MTLRenderPipelineState!
    var gridPipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    var uniforms = Uniforms()
    var params = Params()
    
    public init(metalView: MTKView) throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = try? device.makeDefaultLibrary(bundle: bundle) else {
            throw RendererError.failedToReachGPU
        }
        
        Self.device = device
        self.commandQueue = commandQueue
        self.library = library
        metalView.device = device
        
        super.init()
        
        buildPipelineState(metalView: metalView)
        buildGridPipelineState(metalView: metalView)
        buildDepthStencilState()
        
        metalView.clearColor = MTLClearColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
        metalView.depthStencilPixelFormat = .depth32Float
    }
    
    private func buildPipelineState(metalView: MTKView) {
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
        
        do {
            self.pipelineState = try Self.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildGridPipelineState(metalView: MTKView) {
        let vertexFunction = library.makeFunction(name: "vertex_grid_plane")
        let fragmentFunction = library.makeFunction(name: "fragment_grid_plane")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTLVertexDescriptor.simpleLayout
        
        do {
            self.gridPipelineState = try Self.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildDepthStencilState() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        self.depthStencilState = Self.device.makeDepthStencilState(descriptor: descriptor)
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
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        updateUniforms(scene: scene)
        
        renderEncoder.setDepthStencilState(depthStencilState)
        
        renderEncoder.setRenderPipelineState(gridPipelineState)
        scene.gridPlane.render(encoder: renderEncoder, uniforms: uniforms)
        
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
