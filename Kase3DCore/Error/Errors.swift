//
//  Errors.swift
//  Kase3DCore
//
//  Created by Anda Levente on 2026. 02. 25..
//

import Foundation

public protocol KaseError: Error {
    var localizedDescription: String { get }
}

public enum FileError: KaseError {
    case accessError
    case failedToOpen
    
    public var localizedDescription: String {
        switch self {
        case .accessError:
            String(localized: "Failed to access security-scoped resource")
        case .failedToOpen:
            String(localized: "Failed to open the selected file")
        }
    }
}

public enum MeshError: KaseError {
    case failedToLoad
    
    public var localizedDescription: String {
        switch self {
        case .failedToLoad:
            String(localized: "Failed to load Model Meshes.")
        }
    }
}

public enum ModelError: KaseError {
    case failedToLoad
    
    public var localizedDescription: String {
        switch self {
        case .failedToLoad:
            String(localized: "Failed to load Model.")
        }
    }
}

public enum RendererError: KaseError {
    case failedToReachGPU
    
    public var localizedDescription: String {
        switch self {
        case .failedToReachGPU:
            String(localized: "Unable to reach graphics unit.")
        }
    }
}

public struct GeneralError: KaseError {
    let error: Error
    
    public var localizedDescription: String {
        return error.localizedDescription
    }
}
