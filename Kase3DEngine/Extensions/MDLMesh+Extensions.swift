//
//  MDLMesh+Extensions.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 05. 02..
//

import MetalKit

extension MDLMesh {
    var orientedBoundingBox: OrientedBoundingBox {
        let bbox = boundingBox
        let min = float3(bbox.minBounds)
        let max = float3(bbox.maxBounds)
        let center = (min + max) * 0.5
        let extents = (max - min) * 0.5
        
        let obb = OrientedBoundingBox(
            center: center,
            axes: (float3(1, 0, 0), float3(0, 1, 0), float3(0, 0, 1)),
            extents: extents
        )
        
        print("OBB Center: \(center), extents: \(extents)")
        
        return obb
    }
}
