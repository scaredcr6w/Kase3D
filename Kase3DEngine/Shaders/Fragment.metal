//
//  Fragment.metal
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 22..
//

#include <metal_stdlib>
#import "Lighting.h"
#import "Vertex.h"
using namespace metal;

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              constant Light *lights [[buffer(LightBuffer)]],
                              VertexOut in [[stage_in]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]])
{
    constexpr sampler textureSampler(filter::linear,
                                     mip_filter::linear,
                                     max_anisotropy(8),
                                     address::repeat);
    float3 baseColor = baseColorTexture.sample(textureSampler,
                                               in.uv * params.tiling).rgb;
    
    float3 normalDirection = normalize(in.worldNormal);
    float3 color = phongLighting(normalDirection,
                                 in.worldPosition,
                                 params,
                                 lights,
                                 baseColor);
    return float4(color, 1);
}

fragment float4 fragment_grid_plane(PositionVertexOut in [[stage_in]]) {
    return float4(1, 1, 1, 1);
}

fragment float4 fragment_x_axis(PositionVertexOut in [[stage_in]]) {
    return float4(1, 0, 0, 1);
}

fragment float4 fragment_y_axis(PositionVertexOut in [[stage_in]]) {
    return float4(0, 1, 0, 1);
}

fragment float4 fragment_z_axis(PositionVertexOut in [[stage_in]]) {
    return float4(0, 0, 1, 1);
}

