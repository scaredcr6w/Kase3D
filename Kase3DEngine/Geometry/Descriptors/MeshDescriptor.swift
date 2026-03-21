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
    
    public var isVisible: Bool
    public var submeshDescriptors: [SubmeshDescriptor]
    
    init(mesh: Mesh) {
        self.mesh = mesh
        self.isVisible = mesh.meshProperties.isVisible
        self.submeshDescriptors = mesh.submeshes.map { submesh in
            SubmeshDescriptor(submesh: submesh)
        }
    }
    
    public func toggleVisibility() {
        mesh.meshProperties.isVisible.toggle()
        isVisible = mesh.meshProperties.isVisible
    }
}
