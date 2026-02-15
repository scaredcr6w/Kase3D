//
//  InputController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import GameController

class InputController: @unchecked Sendable {
    static let shared = InputController()
    
    @Locked var leftMouseDown = false
    @Locked var mouseDelta = Point.zero
    @Locked var mouseScroll = Point.zero
    
    @Locked var keysPressed: Set<GCKeyCode> = []
    
    private init() {
        let center = NotificationCenter.default
        
        Task {
            for await notification in center.notifications(for: .GCKeyboardDidConnect) {
                let keyboard = notification.object as? GCKeyboard
                keyboard?.keyboardInput?.keyChangedHandler = { _, _, keyCode, pressed in
                    if pressed {
                        self.keysPressed.insert(keyCode)
                    } else {
                        self.keysPressed.remove(keyCode)
                    }
                }
            }
        }
        
        Task {
            for await notification in center.notifications(for: .GCMouseDidConnect) {
                let mouse = notification.object as? GCMouse
                
                mouse?.mouseInput?.leftButton.pressedChangedHandler = { _, _, pressed in
                    self.leftMouseDown = pressed
                }
                
                mouse?.mouseInput?.mouseMovedHandler = { _, deltaX, deltaY in
                    self.mouseDelta = Point(x: deltaX, y: deltaY)
                }
                
                mouse?.mouseInput?.scroll.valueChangedHandler = { _, xVal, yVal in
                    self.mouseScroll.x = xVal
                    self.mouseScroll.y = yVal
                }
            }
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
