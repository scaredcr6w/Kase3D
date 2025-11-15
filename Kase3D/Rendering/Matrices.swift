//
//  Matrix.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import Foundation

struct Matrix {
    static func projectionMatrix(aspectRatio: Float) -> float4x4 {
        let fov = Float.pi / 2
        let near: Float = 0.1
        let far: Float = 100.0
        
        let f = 1.0 / tan(fov / 2.0)
        
        var matrix = float4x4()
        matrix[0, 0] = f / aspectRatio
        matrix[1, 1] = f
        matrix[2, 2] = (far + near) / (near - far)
        matrix[2, 3] = -1.0
        matrix[3, 2] = (2 * far * near) / (near - far)
        
        return matrix
    }
    
    static func viewMatrix(x: Float, y: Float, z: Float) -> float4x4 {
        float4x4(
            [            1,             0,             0, 0],
            [            0,             1,             0, 0],
            [            0,             0,             1, 0],
            [            x,             y,             z, 1]
        )
    }
}
