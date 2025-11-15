//
//  Shaders.metal
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

#include <metal_stdlib>
#include "Commons.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(
                             VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]]
                             ) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position
    };
    
    return out;
}

fragment float4 fragment_main() {
    return float4 (1.0, 0.6, 0.3, 1.0);
}
