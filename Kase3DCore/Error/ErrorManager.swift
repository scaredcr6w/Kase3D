//
//  ErrorHandler.swift
//  Kase3DCore
//
//  Created by Anda Levente on 2026. 02. 25..
//

import Foundation

@Observable
public final class ErrorManager {
    public static let shared = ErrorManager()
    public var current: PresentedError?
    
    private init() { }
    
    public func present(_ error: any KaseError, retry: (() -> Void)? = nil) {
        current = .init(message: error.localizedDescription, retry: retry)
    }
    
    public func dismiss() {
        guard current != nil else { return }
        
        current = nil
    }
    
    public func map(_ error: Error) -> KaseError {
        return GeneralError(error: error)
    }
    
    public struct PresentedError: Identifiable {
        public let id = UUID()
        public let message: String
        public let retry: (() -> Void)?
    }
}
