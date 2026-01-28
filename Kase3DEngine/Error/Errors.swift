//
//  Errors.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import Foundation

enum MeshError: Error {
    case failedToLoad
}

enum ModelError: Error {
    case failedToLoad
    case failedToGenerate
}

enum RendererError: Error {
    case failedToReachGPU
    
    var localizedDescription: String {
        switch self {
        case .failedToReachGPU:
            "Unable to reach graphics unit."
        }
    }
}
