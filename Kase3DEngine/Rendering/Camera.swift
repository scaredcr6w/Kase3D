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
            matrix = float4x4(eye: position, center: target, up: [0, 1, 0]) // TODO: lookAt matrix causing jitters when forward and up vector cross product is close to 0
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

struct QArcballCamera {
    var distance: Float
    var target: float3
    var orientation: simd_quatf
    
    var screenSize: float2 = [0, 0]
    
    var fov: Float = Float(70).toRadians
    var aspect: Float = 1
    var near: Float = 0.1
    var far: Float = 100
    
    var position: float3 {
        let localOffset = float3(0, 0, distance)
        return target + orientation.act(localOffset)
    }
    
    var viewMatrix: float4x4 {
        let position = position
        let rotationMatrix = float4x4(orientation.conjugate)
        let translationMatrix = float4x4(translation: position)
        
        return rotationMatrix * translationMatrix
    }
    
    var projectionMatrix: float4x4 {
        float4x4(
            projectionFov: fov,
            near: near,
            far: far,
            aspect: aspect
        )
    }
    
    init(distance: Float = 5, target: float3 = .zero) {
        self.distance = distance
        self.target = target
        self.orientation = simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)
    }
    
    mutating func update(size: CGSize) {
        screenSize = float2(Float(size.width), Float(size.height))
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        drag()
        pan()
        zoom()
    }
    
    private mutating func drag() {
        let input = InputController.shared
        let mouseDelta = input.mouseDelta
        let dragSens = Settings.mouseDragSensitivity
        
        let deltaX = mouseDelta.x * dragSens
        let deltaY = mouseDelta.y * dragSens
        
        let yawQuat = simd_quatf(angle: deltaX, axis: float3(0, 1, 0))
        let tempOrientation = yawQuat * orientation
        
        let forward = tempOrientation.act(float3(0, 0, -1))
        let currentPitch = asin(max(-1.0, min(1.0, forward.y)))
        let maxPitch: Float = .pi / 2 - 0.01
        let clampedDeltaY = max(-maxPitch - currentPitch, min(maxPitch - currentPitch, -deltaY))
        
        if abs(clampedDeltaY) > 0.001 {
            let right = tempOrientation.act(float3(1, 0, 0))
            let pitchQuat = simd_quatf(angle: clampedDeltaY, axis: right)
            orientation = pitchQuat * tempOrientation
        } else {
            orientation = tempOrientation
        }
        
        orientation = orientation.normalized
        input.mouseDelta = .zero
    }
    
    private mutating func zoom() {
        let input = InputController.shared
        let scrollSens = Settings.touchZoomSensitivity
        distance -= Float(input.magnification) * scrollSens
        distance = max(0.1, distance)
        input.magnification = 0
    }
    
    private mutating func pan() {
        let input = InputController.shared
        let panInput = input.mousePan
        let panSens = Settings.mousePanSensitivity
        
        let right = orientation.act(float3(1, 0, 0))
        let forward = orientation.act(float3(0, 0, 1))
        
        let pitchAngle = asin(max(-1.0, min(1.0, forward.y)))
        let horizontalFactor = abs(cos(pitchAngle))
        let topDownFactor = abs(sin(pitchAngle))
        
        let horizontalPan = right * panInput.x * panSens
        target += horizontalPan
        
        let forwardPan = float3(forward.x, 0, forward.z)
        let forwardPanNormalized = length(forwardPan) > 0.001 ? normalize(forwardPan) : float3(0, 0, 1)
        target -= forwardPanNormalized * panInput.y * panSens * topDownFactor
        target.y -= panInput.y * panSens * horizontalFactor
        
        input.mousePan = .zero
    }
    
    private func mapToSphere(_ screenPos: float2) -> float3 {
        let x = (2.0 * screenPos.x - screenSize.x) / screenSize.x
        let y = (screenSize.y - 2.0 * screenPos.y) / screenSize.y
        
        let lenghtSquared = x * x + y * y
        
        if lenghtSquared <= 1.0 {
            let z = sqrt(1.0 - lenghtSquared)
            return normalize(float3(x, y, z))
        }
        
        return normalize(float3(x, y, 0))
    }
}
