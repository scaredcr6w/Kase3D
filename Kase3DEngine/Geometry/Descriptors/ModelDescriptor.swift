//
//  ModelDescriptor.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 20..
//

import Foundation
import Combine

@Observable
public final class ModelDescriptor: Identifiable {
    public let id = UUID()
    private let model: Model
    public let modelName: String
    public var isSelected: Bool
    private(set) public var meshDescriptors: [MeshDescriptor]
    private var cancellables = Set<AnyCancellable>()
    
    init(model: Model) {
        self.model = model
        self.modelName = model.properties.name
        self.isSelected = model.properties.isSelected.value
        self.meshDescriptors = model.meshes.map { mesh in
            MeshDescriptor(mesh: mesh)
        }
        
        model.properties.isSelected
            .sink { [weak self] isSelected in
                self?.isSelected = isSelected
            }
            .store(in: &cancellables)
    }
    
    public func toggleSelection() {
        let newValue: Bool = !isSelected
        model.properties.isSelected.send(newValue)
    }
    
    public func setPosition(x: Float) {
        model.transform.position.x = x
    }
    
    public func setPosition(y: Float) {
        model.transform.position.y = y
    }
    
    public func setPosition(z: Float) {
        model.transform.position.z = z
    }
}
