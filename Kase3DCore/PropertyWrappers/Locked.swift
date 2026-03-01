//
//  Locked.swift
//  Kase3DCore
//
//  Created by Anda Levente on 2026. 02. 14..
//

import os

@propertyWrapper
public final class Locked<Value: Sendable>: @unchecked Sendable {
    private let lock = OSAllocatedUnfairLock()
    private var value: Value
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    public var wrappedValue: Value {
        get { lock.withLock { value } }
        set { lock.withLock { value = newValue } }
    }
}
