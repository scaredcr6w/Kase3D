//
//  MeshInspectorView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import SwiftUI
import Kase3DEngine
import Kase3DCore

struct MeshInspectorView: View {
    let sceneManager: SceneManager
    
    @State private var xPosition: String = ""
    @State private var yPosition: String = ""
    @State private var zPosition: String = ""
    @Namespace private var namespace
    
    @Environment(AppCoordinator.self) private var appCoordinator
    
    private var selectedModels: [ModelDescriptor] {
        sceneManager.modelDescriptors.filter { $0.isSelected }
    }
    
    private var shouldPresentTransformView: Bool {
        !selectedModels.isEmpty
    }
    
    var body: some View {
        Group {
            if !sceneManager.modelDescriptors.isEmpty {
                GlassEffectContainer(spacing: 20) {
                    VStack(spacing: 20) {
                        ScrollView {
                            ForEach(sceneManager.modelDescriptors) { model in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(systemName: "cube.transparent")
                                            .font(.callout)
                                        
                                        Text(model.modelName)
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(5)
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        model.toggleSelection()
                                    }
                                    .background {
                                        if model.isSelected {
                                            RoundedRectangle(cornerRadius: 24)
                                                .glassEffect(.regular.tint(.blue))
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        ForEach(model.meshDescriptors) { mesh in
                                            MeshDisclosureGroup(mesh: mesh)
                                        }
                                    }
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .contentMargins(.zero)
                        .scrollIndicators(.hidden)
                        .clipped()
                        .padding(8)
                        .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                        .glassEffectID("meshes", in: namespace)
                        
                        if shouldPresentTransformView {
                            ModelTransformView(
                                sceneManager: sceneManager,
                                xPosition: $xPosition,
                                yPosition: $yPosition,
                                zPosition: $zPosition
                            )
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                            .glassEffectID("transforms", in: namespace)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            ModelTransformView(
                                sceneManager: sceneManager,
                                xPosition: $xPosition,
                                yPosition: $yPosition,
                                zPosition: $zPosition
                            )
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                            .glassEffectID("transforms", in: namespace)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .animation(.easeOut(duration: 0.2), value: shouldPresentTransformView)
                }
            } else {
                VStack {
                    Text("Model not loaded")
                        .font(.callout)
                }
            }
        }
        .onChange(of: selectedModels) { _, newValue in
            setTransformFields(newValue: newValue)
            
            withAnimation(.easeOut(duration: 0.2)) {
                appCoordinator.uiStore.panelCoordinator.selected = .mesh
            }
        }
    }
    
    private func setTransformFields(newValue: [ModelDescriptor]) {
        if newValue.count > 1 {
            setFieldsForMultipleSelected(selected: newValue)
        } else if newValue.count != 0 {
            let selectedModel = newValue[0]
            setFields(for: selectedModel)
        } else {
            resetFields()
        }
    }
    
    private func setFieldsForMultipleSelected(selected: [ModelDescriptor]) {
        let positions = selected.map { $0.getPosition() }
        let xPositionsAvg = positions.reduce(0.0) { $0 + $1.x } / Float(positions.count)
        let yPositionsAvg = positions.reduce(0.0) { $0 + $1.y } / Float(positions.count)
        let zPositionsAvg = positions.reduce(0.0) { $0 + $1.z } / Float(positions.count)
        
        xPosition = "\(xPositionsAvg)"
        yPosition = "\(yPositionsAvg)"
        zPosition = "\(zPositionsAvg)"
    }
    
    private func setFields(for model: ModelDescriptor) {
        let position = model.getPosition()
        
        xPosition = String(position.x)
        yPosition = String(position.y)
        zPosition = String(position.z)
    }
    
    private func resetFields() {
        xPosition = ""
        yPosition = ""
        zPosition = ""
    }
}

struct ModelTransformView: View {
    let sceneManager: SceneManager
    
    @Binding var xPosition: String
    @Binding var yPosition: String
    @Binding var zPosition: String
    
    var body: some View {
        VStack {
            Text("Transform")
                .font(.callout)
                .fontWeight(.semibold)
            
            Form {
                VStack {
                    HStack {
                        TextField("X", text: $xPosition, prompt: Text("X"))
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                for model in sceneManager.modelDescriptors where model.isSelected {
                                    switch validateInput(xPosition) {
                                    case .success(let position):
                                        model.setPosition(x: position)
                                        
                                    case .failure(let error):
                                        ErrorManager.shared.present(error)
                                    }
                                }
                            }
                    }
                    
                    TextField("Y", text: $yPosition, prompt: Text("Y"))
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            for model in sceneManager.modelDescriptors where model.isSelected {
                                switch validateInput(yPosition) {
                                case .success(let position):
                                    model.setPosition(y: position)
                                    
                                case .failure(let error):
                                    ErrorManager.shared.present(error)
                                }
                            }
                        }
                    
                    TextField("Z", text: $zPosition, prompt: Text("Z"))
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            for model in sceneManager.modelDescriptors where model.isSelected {
                                switch validateInput(zPosition) {
                                case .success(let position):
                                    model.setPosition(z: position)
                                    
                                case .failure(let error):
                                    ErrorManager.shared.present(error)
                                }
                            }
                        }
                }
            }
        }
    }
    
    private func validateInput(_ input: String) -> Result<Float, ModelError> { // TODO: Create parser for handling - and + inputs
        if let floatValue = Float(input) {
            return .success(floatValue)
        }
        
        return .failure(.invalidDimension)
    }
}


struct MeshDisclosureGroup: View {
    var mesh: MeshDescriptor
    
    var body: some View {
        DisclosureGroup {
            VStack(spacing: 5) {
                ForEach(mesh.submeshDescriptors) { submesh in
                    HStack {
                        Image(systemName: "squareshape.split.2x2.dotted.inside")
                            .font(.callout)
                        Text(submesh.submeshName)
                            .font(.callout)
                            .lineLimit(1, reservesSpace: false)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                submesh.toggleVisibility()
                            }
                        } label: {
                            Image(systemName: submesh.isVisible ? "eye" : "eye.slash")
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .contentShape(.rect)
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                }
            }
        } label: {
            HStack {
                Image(systemName: "squareshape.split.2x2.dotted.inside")
                    .font(.callout)
                Text(mesh.meshName)
                    .font(.callout)
                
                Spacer()
                
                Button {
                    withAnimation {
                        mesh.toggleVisibility()
                    }
                } label: {
                    Image(systemName: mesh.isVisible ? "eye" : "eye.slash")
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .contentShape(.rect)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
                .padding(.trailing)
            }
        }
        .disclosureGroupStyle(CustomDisclosureGroup())
        .padding(.leading, 4)
    }
}
