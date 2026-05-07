//
//  MeshInspectorView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import SwiftUI
import Kase3DEngine

struct MeshInspectorView: View {
    let sceneManager: SceneManager
    
    @State private var xPosition: Float = 0
    @State private var yPosition: Float = 0
    @State private var zPosition: Float = 0
    @Namespace private var namespace
    
    
    private var didSelectModels: Bool {
        sceneManager.modelDescriptors.contains(where: { $0.isSelected })
    }
    
    var body: some View {
        Group {
            if !sceneManager.modelDescriptors.isEmpty {
                GlassEffectContainer(spacing: 20) {
                    VStack(spacing: 20) {
                        ScrollView {
                            VStack {
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
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                model.toggleSelection()
                                            }
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
                        }
                        .contentMargins(.zero)
                        .clipped()
                        .padding(8)
                        .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                        .glassEffectID("meshes", in: namespace)
                        
                        if didSelectModels { // TODO: No animation when model is selected with hit testing (if selected from the list animation goes through). Getting rid of GlassEffectContainer is the best bet
                            VStack {
                                Text("Transform")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                
                                Form {
                                    HStack {
                                        TextField("X", value: $xPosition, format: .number)
                                            .textFieldStyle(.roundedBorder)
                                            .padding()
                                            .onSubmit {
                                                for model in sceneManager.modelDescriptors where model.isSelected {
                                                    model.setPosition(x: xPosition)
                                                }
                                            }
                                        
                                        TextField("Y", value: $yPosition, format: .number)
                                            .textFieldStyle(.roundedBorder)
                                            .padding()
                                            .onSubmit {
                                                for model in sceneManager.modelDescriptors where model.isSelected {
                                                    model.setPosition(y: yPosition)
                                                }
                                            }
                                        
                                        TextField("Z", value: $zPosition, format: .number)
                                            .textFieldStyle(.roundedBorder)
                                            .padding()
                                            .onSubmit {
                                                for model in sceneManager.modelDescriptors where model.isSelected {
                                                    model.setPosition(z: zPosition)
                                                }
                                            }
                                    }
                                    
                                }
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 24))
                            .glassEffectID("transforms", in: namespace)
                        }
                    }
                }
            } else {
                VStack {
                    Text("Model not loaded")
                        .font(.callout)
                }
            }
        }
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
