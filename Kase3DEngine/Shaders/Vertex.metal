//
//  Vertex.metal
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

#include <metal_stdlib>
#import "Common.h"
#import "Vertex.h"
using namespace metal;

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    float4 worldPosition = uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position,
        .normal = in.normal,
        .uv = in.uv,
        .worldPosition = worldPosition.xyz / worldPosition.w,
        .worldNormal = uniforms.normalMatrix * in.normal
    };
    
    return out;
}

vertex PositionVertexOut vertex_simple(PositionVertexIn in [[stage_in]],
                                       constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    
    PositionVertexOut out {
        .position = position
    };
    
    return out;
}
