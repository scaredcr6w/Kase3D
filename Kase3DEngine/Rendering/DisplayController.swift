//
//  DisplayController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

public class DisplayController: NSObject {
    var sceneManager: SceneManager
    var renderer: Renderer
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    
    public init(sceneManager: SceneManager, metalView: MTKView) {
        renderer = Renderer(metalView: metalView)
        self.sceneManager = sceneManager
        sceneManager.displayScene = DisplayScene()
        super.init()
        metalView.delegate = self
        fps = Double(metalView.preferredFramesPerSecond)
    }
}

extension DisplayController: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        sceneManager.displayScene.update(size: size)
    }
    
    public func draw(in view: MTKView) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        sceneManager.displayScene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: sceneManager.displayScene, in: view)
    }
}
