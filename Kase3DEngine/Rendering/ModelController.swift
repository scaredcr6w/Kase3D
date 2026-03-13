//
//  ModelController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit
import Kase3DCore

@MainActor
public class ModelController: NSObject {
    var sceneManager: SceneManager
    var renderer: Renderer
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    
    let renderContext: any RenderContext
    let inputController: any InputProviding
    let textureService: any TextureLoading
    let meshService: any MeshLoading
    
    public init?(sceneManager: SceneManager, metalView: MTKView) {
        guard let renderContext = MetalRenderContext(metalView: metalView) else { return nil }
        self.renderContext = renderContext
        self.inputController = InputController()
        self.textureService = TextureService(device: renderContext.device)
        self.meshService = MeshService(device: renderContext.device)
        
        guard let renderer = Renderer(metalView: metalView, renderContext: renderContext) else {
            return nil
        }
        
        self.renderer = renderer
        self.sceneManager = sceneManager
        super.init()
        
        sceneManager.configure(context: renderContext, textureService: textureService, meshService: meshService)
        sceneManager.modelScene = ModelScene(renderContext: renderContext)
        
        metalView.delegate = self
        fps = Double(metalView.preferredFramesPerSecond)
    }
}

extension ModelController: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard sceneManager.modelScene != nil else { return }
        sceneManager.modelScene.update(size: size)
    }
    
    public func draw(in view: MTKView) {
        guard sceneManager.modelScene != nil else { return }
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        sceneManager.modelScene.update(deltaTime: Float(deltaTime), inputProviding: inputController)
        renderer.draw(scene: sceneManager.modelScene, in: view)
    }
}

