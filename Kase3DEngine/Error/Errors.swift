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
