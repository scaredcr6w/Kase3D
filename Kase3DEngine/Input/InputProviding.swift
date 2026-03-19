//
//  InputProviding.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 13..
//

import Foundation

/// @mockable
public protocol InputProviding: AnyObject {
    var mouseDelta: float2 { get set }
    var mousePan: float2 { get set }
    var magnification: CGFloat { get set }
    
    func onDragChanged(x: Float, y: Float, previousDrag: CGPoint?)
    func onMagnificationChanged(_ value: CGFloat, previousMagnification: CGFloat?)
    func onPanChanged(x: Float, y: Float, previousPan: CGPoint?)
}
