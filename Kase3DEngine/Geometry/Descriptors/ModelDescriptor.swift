//
//  ModelDescriptor.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 20..
//

import Foundation

@Observable
public final class ModelDescriptor {
    private let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    public var modelName: String {
        model.name
    }
    
    public var meshProperties: [MeshProperties] {
        model.meshes.map { mesh in
            mesh.meshProperties
        }
    }
}
