//
//  ModelButtonView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import SwiftUI
import Kase3DEngine

struct ModelButtonView: View {
    @Environment(SceneManager.self) private var sceneManager
    @Environment(RecentFilesManager.self) private var recentsManager
    private var viewModel: ModelButtonViewModel
    let size: CGFloat = 300
    
    var body: some View {
        VStack {
            Image(systemName: "document")
                .font(.system(size: 60))
                .padding(8)
                .frame(width: size, height: size)
                .glassEffect(.clear.tint(.gray), in: .rect(cornerRadius: 8))
            
            Text(viewModel.bookmark.fileName)
                .font(.title2)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let url = recentsManager.resolveBookmark(viewModel.bookmark) {
                guard url.startAccessingSecurityScopedResource() else {
                    print("Failed to access security-scoped resource")
                    return
                }
                defer { url.stopAccessingSecurityScopedResource() }
                
                sceneManager.loadModel(from: url)
            }
        }
    }
}

extension ModelButtonView {
    init(bookmark: RecentFileBookmark) {
        self.viewModel = ModelButtonViewModel(bookmark: bookmark)
    }
}

#Preview {
    ModelButtonView(bookmark: RecentFileBookmark(
        bookmarkData: Data(),
        fileName: "example_model.usdz"
    ))
}
