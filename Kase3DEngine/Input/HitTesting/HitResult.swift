//
//  HitResult.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 05. 02..
//

import MetalKit

struct HitResult {
    var model: Model
    var ray: Ray
    var parameter: Float
    
    var intersectionPoint: float4 {
        return float4(ray.origin + parameter * ray.direction, 1)
    }
}
