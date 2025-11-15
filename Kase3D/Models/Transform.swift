//
//  Transform.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation

struct Transform {
    var position: SIMD3<Float> = [0, 0, 0]
    var rotation: SIMD3<Float> = [0, 0, 0]
    var scale: Float = 1
}

extension Transform {
    var modelMatrix: matrix_float4x4 {
        let translation = float4x4(
            [         1,          0,          0, 0],
            [         0,          1,          0, 0],
            [         0,          0,          1, 0],
            [position.x, position.y, position.z, 1]
        )
        
        let rotationX = float4x4(
            [1,                0,               0, 0],
            [0,  cos(rotation.x), sin(rotation.x), 0],
            [0, -sin(rotation.x), cos(rotation.x), 0],
            [0,                0,               0, 1]
        )
        let rotationY = float4x4(
            [cos(rotation.y), 0, -sin(rotation.y), 0],
            [              0, 1,                0, 0],
            [sin(rotation.y), 0,  cos(rotation.y), 0],
            [              0, 0,                0, 1]
        )
        let rotationZ = float4x4(
            [ cos(rotation.z), sin(rotation.z), 0, 0],
            [-sin(rotation.z), cos(rotation.z), 0, 0],
            [               0,               0, 1, 0],
            [               0,               0, 0, 1]
        )
        let rotation  = rotationX * rotationY * rotationZ
        
        var scale = matrix_identity_float4x4
        scale.columns.0.x = self.scale
        scale.columns.1.y = self.scale
        scale.columns.2.z = self.scale
        
        let modelMatrix = translation * rotation * scale
        
        return modelMatrix
    }
}

protocol Transformable {
    var transform: Transform { get set }
}

extension Transformable {
    var position: SIMD3<Float> {
        get { transform.position }
        set { transform.position = newValue }
    }
    
    var rotation: SIMD3<Float> {
        get { transform.rotation }
        set { transform.rotation = newValue }
    }
    
    var scale: Float {
        get { transform.scale }
        set { transform.scale = newValue }
    }
}
