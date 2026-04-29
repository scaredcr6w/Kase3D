//
//  PrimitiveBundle.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 04. 29..
//

import MetalKit

protocol PrimitiveBundle {
    func render(encoder: MTLRenderCommandEncoder, uniforms: Uniforms)
}
