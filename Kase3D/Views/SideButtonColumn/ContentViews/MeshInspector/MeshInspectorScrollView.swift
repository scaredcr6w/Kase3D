//
//  MeshInspectorScrollView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 05. 15..
//

import SwiftUI
import Kase3DEngine

struct MeshInspectorScrollView: View {
    let sceneManager: SceneManager
    
    var body: some View {
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
    }
}
