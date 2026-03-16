//
//  InputProviding.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import Foundation

/// @mockable
protocol InputProviding: AnyObject {
    var mouseDelta: float2 { get set }
    var mousePan: float2 { get set }
    var magnification: CGFloat { get set }
}
