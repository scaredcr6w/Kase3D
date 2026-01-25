//
//  InputController.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import GameController

class InputController {
    static let shared = InputController()
    
    var leftMouseDown = false
    var mouseDelta = Point.zero
    var mouseScroll = Point.zero
    
    var keysPressed: Set<GCKeyCode> = []
    
    private init() {
        let center = NotificationCenter.default
        
        center.addObserver(
            forName: .GCKeyboardDidConnect,
            object: nil,
            queue: nil) { notification in
                let keyboard = notification.object as? GCKeyboard
                keyboard?.keyboardInput?.keyChangedHandler = { _, _, keyCode, pressed in
                    if pressed {
                        self.keysPressed.insert(keyCode)
                    } else {
                        self.keysPressed.remove(keyCode)
                    }
                }
            }
        
        center.addObserver(
            forName: .GCMouseDidConnect,
            object: nil,
            queue: nil) { notification in
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
        
        #if os(macOS)
        NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown], handler: { _ in nil })
        #endif
    }
    
    struct Point {
        var x: Float
        var y: Float
        static let zero = Point(x: 0, y: 0)
    }
}
