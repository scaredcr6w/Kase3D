//
//  SceneManager.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 26..
//

import Foundation
import Kase3DCore

@Observable
@MainActor
public final class SceneManager {
    var modelScene: ModelScene!
    public var hasLoadedAnyModel: Bool = false
    
    var context: (any RenderContext)?
    var textureService: (any TextureLoading)?
    var meshService: (any MeshLoading)?
    
    public init() { }
    
    public func loadModel(from assetURL: URL) {
        do {
            guard let meshService, let textureService, modelScene != nil else { return }
            let meshes = try meshService.loadMeshes(from: assetURL, textureLoader: textureService)
            let model = Model(meshes: meshes, name: assetURL.lastPathComponent)
            modelScene.models.append(model)
            hasLoadedAnyModel = true
        } catch {
            ErrorManager.shared.present(ModelError.failedToLoad)
        }
    }
    
    func configure(context: RenderContext, textureService: TextureLoading, meshService: MeshLoading) {
        self.context = context
        self.textureService = textureService
        self.meshService = meshService
    }
}
