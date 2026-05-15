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
    @Environment(AppCoordinator.self) private var appCoordinator
    
    @State private var xPosition: String = ""
    @State private var yPosition: String = ""
    @State private var zPosition: String = ""
    @State private var xRotation: String = ""
    @State private var yRotation: String = ""
    @State private var zRotation: String = ""
    
    @Namespace private var namespace
    
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
                        MeshInspectorScrollView(sceneManager: sceneManager)
                            .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                            .glassEffectID("meshes", in: namespace)
                        
                        if shouldPresentTransformView {
                            ModelTransformView(
                                sceneManager: sceneManager,
                                title: "Position",
                                x: $xPosition,
                                y: $yPosition,
                                z: $zPosition,
                                setX: { $0.setPosition(x: $1) },
                                setY: { $0.setPosition(y: $1) },
                                setZ: { $0.setPosition(z: $1) }
                            )
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                            .glassEffectID("transforms", in: namespace)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            ModelTransformView(
                                sceneManager: sceneManager,
                                title: "Rotation",
                                x: $xRotation,
                                y: $yRotation,
                                z: $zRotation,
                                setX: { $0.setRotation(x: $1) },
                                setY: { $0.setRotation(y: $1) },
                                setZ: { $0.setRotation(z: $1) }
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
        
        let rotations = selected.map { $0.getRotation() }
        let xRotationsAvg = rotations.reduce(0.0) { $0 + $1.x } / Float(rotations.count)
        let yRotationsAvg = rotations.reduce(0.0) { $0 + $1.y } / Float(rotations.count)
        let zRotationsAvg = rotations.reduce(0.0) { $0 + $1.z } / Float(rotations.count)
        
        xRotation = String(xRotationsAvg)
        yRotation = String(yRotationsAvg)
        zRotation = String(zRotationsAvg)
    }
    
    private func setFields(for model: ModelDescriptor) {
        let position = model.getPosition()
        
        xPosition = String(position.x)
        yPosition = String(position.y)
        zPosition = String(position.z)
        
        let rotation = model.getRotation()
        xRotation = String(rotation.x)
        yRotation = String(rotation.y)
        zRotation = String(rotation.z)
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
                .padding(.trailing, 4)
            }
        }
        .disclosureGroupStyle(CustomDisclosureGroup())
        .padding(.leading, 4)
    }
}
