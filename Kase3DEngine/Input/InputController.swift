//
//  InputController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import GameController

final class InputController: @unchecked Sendable {
    static let shared = InputController()
    
    @Locked var mouseDelta = Point.zero
    @Locked var magnification: CGFloat = 0
    @Locked var mousePan = Point.zero
    
    private init() {
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged) { event in
            self.mouseDelta = Point(x: Float(event.deltaX), y: -Float(event.deltaY))
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .magnify) { event in
            self.magnification = event.magnification
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
            self.mousePan = Point(x: Float(event.scrollingDeltaX), y: Float(event.scrollingDeltaY))
            return event
        }
    }
    
    struct Point: Sendable {
        var x: Float
        var y: Float
        static let zero = Point(x: 0, y: 0)
    }
}

extension NotificationCenter {
    func notifications(for name: Notification.Name) -> NotificationCenter.Notifications {
        notifications(named: name)
    }
}
