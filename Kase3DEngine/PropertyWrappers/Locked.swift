//
//  Locked.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 02. 14..
//

import os

@propertyWrapper
final class Locked<Value: Sendable>: @unchecked Sendable {
    private let lock = OSAllocatedUnfairLock()
    private var value: Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { lock.withLock { value } }
        set { lock.withLock { value = newValue } }
    }
}
