//
//  Camera.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import CoreGraphics

protocol Camera {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float, inputProviding: InputProviding)
}

struct ArcballCamera: Camera {
    var distance: Float
    var target: float3
    var orientation: simd_quatf
    
    var screenSize: float2 = [0, 0]
    var fov: Float = Float(70).toRadians
    var aspect: Float = 1
    var near: Float = 0.1
    var far: Float = 100
    var minDistance: Float = 0.1
    var maxDistance: Float = 20
    
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
    
    init(distance: Float = 2.5, target: float3 = .zero) {
        self.distance = distance
        self.target = target
        self.orientation = simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)
    }
    
    mutating func update(size: CGSize) {
        screenSize = float2(Float(size.width), Float(size.height))
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float, inputProviding: InputProviding) {
        drag(inputProviding.mouseDelta)
        pan(inputProviding.mousePan)
        zoom(Float(inputProviding.magnification))
        
        inputProviding.mouseDelta = .zero
        inputProviding.mousePan = .zero
        inputProviding.magnification = .zero
    }
    
    mutating func drag(_ mouseDelta: float2) {
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
    }
    
    mutating func zoom(_ magnification: Float) {
        let scrollSens = Settings.touchZoomSensitivity
        distance -= magnification * scrollSens
        distance = max(minDistance, min(maxDistance, distance))
    }
    
    mutating func pan(_ panInput: float2) {
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
    }
}
