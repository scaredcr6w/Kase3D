//
//  ModelScene.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import MetalKit

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
            print("start hit testing")
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
            print("Hit model \(hit.model.name)\nat \(hit.intersectionPoint)")
            print("Parameter: \(hit.parameter)")
        }
        
        inputProviding.location = .zero
    }
    
    private func hitTest(_ ray: Ray) -> HitResult? {
        var nearest: HitResult?
        var nearestT = Float.greatestFiniteMagnitude
        
        for model in models {
            let invModel = model.transform.modelMatrix.inverse
            let localRay = invModel * ray
            
            for mesh in model.meshes where mesh.meshProperties.isVisible {
                if let hit = mesh.orientedBoundingBox.intersect(ray: localRay) {
                    let t = hit.w
                    if t >= 0 && t < nearestT {
                        nearestT = t
                        
                        let worldPoint = model.transform.modelMatrix * hit
                        let worldParameter = ray.interpolate(worldPoint)
                        
                        nearest = HitResult(model: model, ray: ray, parameter: worldParameter)
                    }
                }
            }
        }
        
        return nearest
    }
}
