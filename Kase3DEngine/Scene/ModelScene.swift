//
//  ModelScene.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit
import Combine

public struct ModelScene {
    var models: [Model] = []
    var gridPlane: Plane
    var camera = ArcballCamera()
    let lighting = SceneLighting()
    
    init(renderContext: RenderContext) {
        gridPlane = Plane(size: 100, renderContext: renderContext)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        camera.update(deltaTime: deltaTime, inputProviding: inputProviding)
        if inputProviding.location != .zero {
            shouldHitTest(inputProviding: inputProviding)
        }
    }
    
    private func shouldHitTest(inputProviding: InputProviding) {
        let point = inputProviding.location
        let screenSize = camera.screenSize
        
        let clipX = (2 * point.x) / screenSize.x - 1
        let clipY = 1 - (2 * point.y) / screenSize.y
        let viewProjection = camera.projectionMatrix * camera.viewMatrix
        let inverseVP = viewProjection.inverse
        
        let nearClip = float4(clipX, clipY, 0, 1)
        let farClip = float4(clipX, clipY, 1, 1)
        
        var nearWorld = inverseVP * nearClip
        nearWorld /= nearWorld.w
        
        var farWorld = inverseVP * farClip
        farWorld /= farWorld.w
        
        let origin = nearWorld.xyz
        let direction = normalize(farWorld.xyz - nearWorld.xyz)
        
        let ray = Ray(origin: origin, direction: direction)
        if let hit = hitTest(ray) {
            deselect(models: models)
            select(model: hit.model)
        }
        
        inputProviding.location = .zero
    }
    
    private func hitTest(_ ray: Ray) -> HitResult? {
        struct CandidateHit {
            let model: Model
            let distance: Float
            let volume: Float
        }
        
        var candidates: [CandidateHit] = []
        
        for model in models {
            let invModel = model.transform.modelMatrix.inverse
            let localRay = invModel * ray
            
            for mesh in model.meshes where mesh.meshProperties.isVisible {
                if let hit = mesh.orientedBoundingBox.intersect(ray: localRay) {
                    let localHitPoint = float4(hit.xyz, 1)
                    let worldPoint = model.transform.modelMatrix * localHitPoint
                    let distance = length(worldPoint.xyz - ray.origin)
                    let scaleFactor = model.transform.scale
                    let worldVolume = mesh.orientedBoundingBox.volume * scaleFactor * scaleFactor * scaleFactor
                    
                    candidates.append(CandidateHit(model: model, distance: distance, volume: worldVolume))
                }
            }
        }
        
        guard !candidates.isEmpty else { return nil }
        
        candidates.sort { a, b in
            return a.volume < b.volume
        }
        
        let best = candidates[0]
        
        return HitResult(model: best.model, ray: ray, parameter: best.distance)
    }
    
    private func select(model: Model) {
        model.properties.isSelected.send(true)
    }
    
    private func deselect(models: [Model]) {
        models.forEach { $0.properties.isSelected.send(false) }
    }
}
