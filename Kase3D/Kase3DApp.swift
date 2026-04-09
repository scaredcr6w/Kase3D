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
        Group {
            WindowGroup("Welcome", id: WindowKeys.welcome.rawValue) {
                WelcomeView()
                    .environment(appCoordinator)
            }
            .defaultSize(width: 400, height: 300)
            
            WindowGroup("Editor", id: WindowKeys.editor.rawValue, for: FileInfo.self) { $fileInfo in
                if let fileInfo {
                    EditorView()
                        .environment(appCoordinator)
                        .onAppear {
                            if fileInfo.path.startAccessingSecurityScopedResource() {
                                defer { fileInfo.path.stopAccessingSecurityScopedResource() }
                                appCoordinator.loadModel(from: fileInfo.path)
                            } else {
                                appCoordinator.appStore.isFileImporterPresented = false
                                ErrorManager.shared.present(FileError.accessError) {
                                    appCoordinator.appStore.isFileImporterPresented = true
                                }
                            }
                        }
                }
            }
            .restorationBehavior(.disabled)
            .windowResizability(.automatic)
            .defaultWindowPlacement { content, context in
                let size = content.sizeThatFits(.unspecified)
                let posX = context.defaultDisplay.bounds.midX - (size.width / 2)
                let posY = context.defaultDisplay.bounds.maxY - size.height
                let position = CGPoint(x: posX, y: posY)
                return WindowPlacement(position, size: context.defaultDisplay.bounds.size)
            }
        }
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

enum WindowKeys: String {
    case welcome = "welcome"
    case editor = "editor"
}
