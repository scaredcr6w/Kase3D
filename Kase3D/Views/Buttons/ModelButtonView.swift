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
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
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
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1))
                
                appCoordinator.startAccessing(bookmark: viewModel.bookmark) { url in
                    openWindow(
                        id: WindowKeys.editor.rawValue,
                        value: FileInfo(
                            fileName: viewModel.bookmark.fileName,
                            path: url
                        )
                    )
                    dismissWindow(id: WindowKeys.welcome.rawValue)
                }
            }
        }
    }
}

extension ModelButtonView {
    init(bookmark: RecentFileBookmark) {
        self.viewModel = ModelButtonViewModel(bookmark: bookmark)
    }
}
