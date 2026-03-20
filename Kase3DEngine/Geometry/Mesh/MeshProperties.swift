//
//  MeshProperties.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 20..
//

import Foundation

public struct MeshProperties: Identifiable {
    public let id = UUID()
    public let meshName: String
    public var isVisible: Bool = true
}
