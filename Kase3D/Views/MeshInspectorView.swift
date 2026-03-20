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
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(modelDescriptor.meshProperties) { mesh in
                            HStack {
                                Image(systemName: "squareshape.split.2x2.dotted.inside")
                                Text(mesh.meshName)
                            }
                        }
                    }
                }
                .padding(.leading)
            }
        } else {
            VStack {
                Text("Model not loaded")
            }
        }
    }
}
