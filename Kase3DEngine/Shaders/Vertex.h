//
//  Vertex.h
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 25..
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
    float3 worldPosition;
    float3 worldNormal;
};

