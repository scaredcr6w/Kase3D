//
//  Lighting.h
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 25..
//

#ifndef Lighting_h
#define Lighting_h

#import "Common.h"

float3 phongLighting(float3 normal,
                     float3 position,
                     constant Params &params,
                     constant Light *lights,
                     float3 baseColor);

#endif /* Lighting_h */
