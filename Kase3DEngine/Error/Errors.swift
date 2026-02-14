//
//  Errors.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import Foundation

enum MeshError: Error {
    case failedToLoad
    
    var localizedDescription: String {
        switch self {
        case .failedToLoad:
            String(localized: "Failed to load Model Meshes.")
        }
    }
}

enum ModelError: Error {
    case failedToLoad
    
    var localizedDescription: String {
        switch self {
        case .failedToLoad:
            String(localized: "Failed to load Model.")
        }
    }
}

enum RendererError: Error {
    case failedToReachGPU
    
    var localizedDescription: String {
        switch self {
        case .failedToReachGPU:
            String(localized: "Unable to reach graphics unit.")
        }
    }
}
