//
//  InputController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//
import Kase3DCore
import AppKit

final class InputController: InputProviding, @unchecked Sendable {
    @Locked var mouseDelta = float2.zero
    @Locked var magnification: CGFloat = 0
    @Locked var mousePan = float2.zero
    
    init() {
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged) { event in
            self.mouseDelta = float2(Float(event.deltaX), -Float(event.deltaY))
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .magnify) { event in
            self.magnification = event.magnification
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
            self.mousePan = float2(Float(event.scrollingDeltaX), Float(event.scrollingDeltaY))
            return event
        }
    }
}
