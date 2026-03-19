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
    @State private var appCoordinator: AppCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appCoordinator)
                .fileImporter(
                    isPresented: $appCoordinator.appStore.isFileImporterPresented,
                    allowedContentTypes: [.usdz]) { result in
                        switch result {
                        case .success(let url):
                            if url.startAccessingSecurityScopedResource() {
                                defer { url.stopAccessingSecurityScopedResource() }
                                appCoordinator.addRecentFile(url)
                                appCoordinator.loadModel(from: url)
                            } else {
                                appCoordinator.appStore.isFileImporterPresented = false
                                ErrorManager.shared.present(FileError.accessError) {
                                    appCoordinator.appStore.isFileImporterPresented = true
                                }
                            }
                        case .failure(let error):
                            let kaseError = ErrorManager.shared.map(error)
                            ErrorManager.shared.present(kaseError)
                        }
                    }
        }
        .windowResizability(.automatic)
        .commands {
            CommandGroup(after: .newItem) {
                Button("Import File...") {
                    appCoordinator.appStore.isFileImporterPresented = true
                }
                .keyboardShortcut("i")
                
                Menu("Open Recent") {
                    ForEach(appCoordinator.recentsManager.recentBookmarks) { bookmark in
                        Button(bookmark.fileName) {
                            appCoordinator.openRecent(bookmark)
                        }
                    }
                    
                    Divider()
                    
                    Button("Clear Menu") {
                        appCoordinator.clearRecents()
                    }
                }
            }
        }
    }
}
