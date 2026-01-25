//
//  Renderer.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

import MetalKit

public final class Renderer: NSObject {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var library: MTLLibrary
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    public init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else {
            fatalError("Cannot reach GPU")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.library = library
        metalView.device = device
        
        super.init()
        
        buildPipelineState(metalView: metalView)
        buildDepthStencilState()
        
        metalView.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 0.6)
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
            self.pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func buildDepthStencilState() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        self.depthStencilState = device.makeDepthStencilState(descriptor: descriptor)
    }
}
