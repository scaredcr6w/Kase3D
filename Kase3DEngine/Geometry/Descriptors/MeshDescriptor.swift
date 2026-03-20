//
//  MeshDescriptor.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 20..
//

import Foundation

@Observable
public final class MeshDescriptor: Identifiable {
    public let id = UUID()
    private let mesh: Mesh
    
    public var meshName: String {
        mesh.meshProperties.meshName
    }
    
    public var isVisible: Bool {
        mesh.meshProperties.isVisible
    }
    
    init(mesh: Mesh) {
        self.mesh = mesh
    }
    
    public var submeshProperties: [SubmeshProperties] {
        mesh.submeshes.map { submesh in
            submesh.submeshProperties
        }
    }
}
