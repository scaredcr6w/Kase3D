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
    
    var body: some View {
        if let modelDescriptor = sceneManager.modelDescriptor {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "cube.transparent")
                        .font(.callout)
                    Text(modelDescriptor.modelName)
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(modelDescriptor.meshDescriptors) { mesh in
                            DisclosureGroup {
                                VStack(spacing: 5) {
                                    ForEach(mesh.submeshProperties) { submesh in
                                        HStack {
                                            Image(systemName: "squareshape.split.2x2.dotted.inside")
                                                .font(.callout)
                                            Text(submesh.submeshName)
                                                .font(.callout)
                                                .lineLimit(1, reservesSpace: false)
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
                                    .padding(.horizontal)
                                }
                            }
                            .disclosureGroupStyle(CustomDisclosureGroup())
                            .padding(.leading, 4)
                            .frame(maxWidth: 350, alignment: .leading)
                        }
                    }
                }
                .frame(maxHeight: 350)
            }
        } else {
            VStack {
                Text("Model not loaded")
                    .font(.callout)
            }
        }
    }
}
