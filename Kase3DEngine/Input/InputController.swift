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
    
    public func onDragChanged(_ translation: CGSize) {
        self.mouseDelta = float2(Float(translation.width), -Float(translation.height))
    }
    
    public func onMagnificationChanged(_ value: CGFloat) {
        magnification = value
    }
}
