//
//  Camera.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import CoreGraphics

protocol Camera: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float)
}

struct ArcballCamera: Camera {
    var transform: Transform = .init()
    var aspect: Float = 1
    var fov = Float(70).toRadians
    var near: Float = 0.1
    var far: Float = 100
    let minDistance: Float = 0
    let maxDistance: Float = 20
    var target: float3 = [0, 0, 0]
    var distance: Float = 0
    
    var shift: float3 = [0, 0, 0]
    
    var projectionMatrix: float4x4 {
        float4x4(
            projectionFov: fov,
            near: near,
            far: far,
            aspect: aspect
        )
    }
    
    var viewMatrix: float4x4 {
        let matrix: float4x4
        if target == position {
            matrix = (float4x4(translation: target) * float4x4(rotationYXZ: rotation)).inverse
        } else {
            matrix = float4x4(eye: position, center: target, up: [0, 1, 0])
        }
        
        return matrix
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        let input = InputController.shared
        
        let panSens = Settings.mousePanSensitivity
        let panInput = float3(input.mousePan.x * panSens, 0, -input.mousePan.y * panSens)
        let yawMatrix = float4x4(rotationY: rotation.y)
        let horizontalPan = (yawMatrix * float4(panInput.x, 0, 0, 0)).xyz
        target -= horizontalPan
        let forwardPan = (yawMatrix * float4(0, 0, panInput.z, 0)).xyz
        let horizontalFactor = abs(cos(rotation.x))
        let topDownFactor = abs(sin(rotation.x))
        target -= forwardPan * topDownFactor
        target.y -= panInput.z * horizontalFactor
        input.mousePan = .zero
        
        let scrollSens = Settings.touchZoomSensitivity
        distance -= Float((input.magnification)) * scrollSens
        distance = min(maxDistance, distance)
        distance = max(minDistance, distance)
        input.magnification = 0
        
        let dragSens = Settings.mouseDragSensitivity
        rotation.x += input.mouseDelta.y * dragSens
        rotation.y += input.mouseDelta.x * dragSens
        rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
        input.mouseDelta = .zero
        
        let rotateMatrix = float4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        let distanceVector = float4(0, 0, -distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        position = target + rotatedVector.xyz
    }
}
