//
//  Commons.h
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

#ifndef Commons_h
#define Commons_h
#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;


#endif /* Commons_h */
