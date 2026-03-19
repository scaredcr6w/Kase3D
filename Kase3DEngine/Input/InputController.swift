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
    
    init() { }
    
    public func onDragChanged(x: Float, y: Float, previousDrag: CGPoint?) {
        #if os(macOS)
        mouseDelta = float2(x, -y)
        #elseif os(iOS)
        guard let previousDrag else { return }
        let width = Float(previousDrag.x)
        let height = Float(previousDrag.y)
        mouseDelta = float2(x - width, -(y - height))
        #endif
    }
    
    public func onMagnificationChanged(_ value: CGFloat, previousMagnification: CGFloat?) {
        #if os(macOS)
        magnification = value
        #elseif os(iOS)
        guard let previousMagnification else { return }
        let magnification = value - previousMagnification
        self.magnification = magnification
        #endif
    }
    
    public func onPanChanged(x: Float, y: Float, previousPan: CGPoint?) {
        #if os(macOS)
        mousePan = float2(x, y)
        #elseif os(iOS)
        guard let previousPan else { return }
        let width = Float(previousPan.x)
        let height = Float(previousPan.y)
        mousePan = float2(x - width, y - height)
        #endif
    }
}
