//
//  Kase3DApp.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI
import UniformTypeIdentifiers
import Kase3DEngine
import Kase3DCore

@main
struct Kase3DApp: App {
    @State private var isFileImporterPresented: Bool = false
    @State private var appCoordinator: AppCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appCoordinator)
        }
        .windowResizability(.automatic)
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
                                appCoordinator.recentsManager.addRecentFile(url)
                                appCoordinator.loadModel(from: url)
                            } else {
                                isFileImporterPresented = false
                                ErrorManager.shared.present(FileError.accessError) {
                                    isFileImporterPresented = true
                                }
                            }
                        case .failure(let error):
                            let kaseError = ErrorManager.shared.map(error)
                            ErrorManager.shared.present(kaseError)
                        }
                    }
                
                Menu("Open Recent") {
                    ForEach(appCoordinator.recentsManager.recentBookmarks) { bookmark in
                        Button(bookmark.fileName) {
                            appCoordinator.recentsManager.startAccessing(bookmark: bookmark, appCoordinator.sceneManager.loadModel(from:))
                        }
                    }
                    
                    Divider()
                    
                    Button("Clear Menu") {
                        appCoordinator.recentsManager.clearRecents()
                    }
                }
            }
        }
    }
}
