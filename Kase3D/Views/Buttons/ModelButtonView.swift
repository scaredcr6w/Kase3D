//
//  ModelButtonView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import SwiftUI
import Kase3DEngine

struct ModelButtonView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    private var viewModel: ModelButtonViewModel
    let size: CGFloat = 300
    
    var body: some View {
        VStack {
            Image(systemName: "document")
                .font(.system(size: 60))
                .padding(8)
                .frame(width: size, height: size)
                .glassEffect(.clear.tint(.gray).interactive(), in: .rect(cornerRadius: 8))
            
            Text(viewModel.bookmark.fileName)
                .font(.title2)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            appCoordinator.recentsManager.startAccessing(bookmark: viewModel.bookmark, appCoordinator.sceneManager.loadModel(from:))
        }
    }
}

extension ModelButtonView {
    init(bookmark: RecentFileBookmark) {
        self.viewModel = ModelButtonViewModel(bookmark: bookmark)
    }
}
