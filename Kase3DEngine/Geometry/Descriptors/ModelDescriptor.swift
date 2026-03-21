//
//  ModelDescriptor.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 20..
//

import Foundation

@Observable
public final class ModelDescriptor: Identifiable {
    public let id = UUID()
    private let model: Model
    public let modelName: String
    private(set) public var meshDescriptors: [MeshDescriptor]
    
    init(model: Model) {
        self.model = model
        self.modelName = model.name
        self.meshDescriptors = model.meshes.map { mesh in
            MeshDescriptor(mesh: mesh)
        }
    }
}
