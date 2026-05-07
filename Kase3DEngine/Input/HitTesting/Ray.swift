//
//  Ray.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 05. 02..
//

import MetalKit

public struct Ray {
    var origin: float3
    var direction: float3
    
    public init(origin: float3, direction: float3) {
        self.origin = origin
        self.direction = direction
    }
    
    static func *(transform: float4x4, ray: Ray) -> Ray {
        let originT = (transform * float4(ray.origin, 1)).xyz
        let directionT = (transform * float4(ray.direction, 0)).xyz
        return Ray(origin: originT, direction: directionT)
    }
    
    func interpolate(_ point: float4) -> Float {
        return length(point.xyz - origin) / length(direction)
    }
}
