//
//  InputController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import Foundation
import Kase3DCore

final public class InputController: InputProviding, @unchecked Sendable {
    @Locked public var mouseDelta = float2.zero
    @Locked public var magnification: CGFloat = 0
    @Locked public var mousePan = float2.zero
    @Locked public var location = float2.zero
    
    init() { }
    
    public func onDragChanged(x: Float, y: Float) {
        mouseDelta = float2(x, -y)
    }
    
    public func onMagnificationChanged(_ value: CGFloat) {
        magnification = value
    }
    
    public func onPanChanged(x: Float, y: Float) {
        mousePan = float2(x, y)
    }
    
    public func onTapLocation(x: Float, y: Float) {
        location = float2(x: x, y: y)
    }
}
