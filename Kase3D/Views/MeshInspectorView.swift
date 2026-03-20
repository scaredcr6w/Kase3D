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
                    Text(modelDescriptor.modelName)
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
                                            Text(submesh.submeshName)
                                                .lineLimit(1, reservesSpace: false)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "squareshape.split.2x2.dotted.inside")
                                    Text(mesh.meshName)
                                }
                            }
                            .padding(.leading, 4)
                            .frame(maxWidth: 350, alignment: .leading)
                        }
                    }
                    .padding(.trailing)
                }
                .frame(maxHeight: 200)
            }
        } else {
            VStack {
                Text("Model not loaded")
            }
        }
    }
}
