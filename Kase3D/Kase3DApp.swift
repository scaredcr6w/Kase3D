//
//  Kase3DApp.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI
import UniformTypeIdentifiers
import Kase3DEngine

@main
struct Kase3DApp: App {
    @State private var isFileImporterPresented: Bool = false
    private var sceneManager: SceneManager = .init()
    private var recentsManager: RecentFilesManager = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sceneManager)
                .environment(recentsManager)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Import File...") {
                  isFileImporterPresented = true
                }
                .keyboardShortcut("i")
                .fileImporter(
                    isPresented: $isFileImporterPresented,
                    allowedContentTypes: [.usdz]) { result in
                        switch result {
                        case .success(let url):
                            if url.startAccessingSecurityScopedResource() {
                                defer { url.stopAccessingSecurityScopedResource() }
                                recentsManager.addRecentFile(url)
                                sceneManager.loadModel(from: url)
                            } else {
                                print("Failed to access security-scoped resource")
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                
                Menu("Open Recent") {
                    ForEach(recentsManager.recentBookmarks, id: \.fileName) { bookmark in
                        Button(bookmark.fileName) {
                            if let url = recentsManager.resolveBookmark(bookmark) {
                                if url.startAccessingSecurityScopedResource() {
                                    defer { url.stopAccessingSecurityScopedResource() }
                                    sceneManager.loadModel(from: url)
                                } else {
                                    print("Failed to access security-scoped resource")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
