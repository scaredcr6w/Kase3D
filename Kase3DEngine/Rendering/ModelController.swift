//
//  ModelController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

public class ModelController: NSObject {
    var sceneManager: SceneManager
    var renderer: Renderer
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    
    public init(sceneManager: SceneManager, metalView: MTKView) throws {
        renderer = try Renderer(metalView: metalView)
        self.sceneManager = sceneManager
        sceneManager.modelScene = ModelScene()
        super.init()
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
        sceneManager.modelScene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: sceneManager.modelScene, in: view)
    }
}
