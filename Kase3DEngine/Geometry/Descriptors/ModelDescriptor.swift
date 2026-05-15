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
    private var model: Model
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
    
    public func getPosition() -> float3 {
        model.transform.position
    }
    
    public func setRotation(x: Float) {
        model.transform.rotation.x = x.toRadians
    }
    
    public func setRotation(y: Float) {
        model.transform.rotation.y = y.toRadians
    }
    
    public func setRotation(z: Float) {
        model.transform.rotation.z = z.toRadians
    }
    
    public func getRotation() -> float3 {
        model.transform.rotation
    }
    
    public func setScale(_ scale: Float) {
        model.scale = scale
    }
    
    public func getScale() -> Float {
        model.transform.scale
    }
}

extension ModelDescriptor: Equatable {
    public static func == (lhs: ModelDescriptor, rhs: ModelDescriptor) -> Bool {
        lhs === rhs
    }
}
