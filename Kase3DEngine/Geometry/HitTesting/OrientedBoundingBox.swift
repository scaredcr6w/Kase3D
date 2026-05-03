//
//  OrientedBoundingBox.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 05. 02..
//

import MetalKit

struct OrientedBoundingBox {
    var center: float3
    var axes: (float3, float3, float3)
    var extents: float3
    
    func intersect(ray: Ray) -> float4? {
        var tMin = -Float.greatestFiniteMagnitude
        var tMax = Float.greatestFiniteMagnitude
        
        let p = center - ray.origin
        let axes = [axes.0, axes.1, axes.2]
        let ext = extents
        
        for i in 0..<3 {
            let axis = axes[i]
            let e = simd_dot(axis, p)
            let f = simd_dot(axis, ray.direction)
            let extent = ext[i]
            
            if abs(f) > 1e-5 {
                var t1 = (e + extent) / f
                var t2 = (e - extent) / f
                if t1 > t2 {
                    swap(&t1, &t2)
                }
                
                tMin = max(tMin, t1)
                tMax = min(tMax, t2)
                
                if tMin > tMax { return nil }
            } else {
                if -e - extent > 0 || -e + extent < 0 { return nil }
            }
        }
        
        if tMax < 0 { return nil }
        
        let tHit = tMin >= 0 ? tMin : tMax
        let hitPoint = ray.origin + ray.direction * tHit
        
        return float4(hitPoint, tHit)
    }
}
