//
//  WelcomeView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import SwiftUI
import Kase3DCore
import UniformTypeIdentifiers

struct WelcomeView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var pendingURL: URL?

    private var isFileImporterPresentedBinding: Binding<Bool> {
        Binding(
            get: { appCoordinator.appStore.isFileImporterPresented },
            set: { appCoordinator.appStore.isFileImporterPresented = $0 }
        )
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                #if os(macOS)
                VStack {
                    Button {
                        dismissWindow(id: WindowKeys.welcome.rawValue)
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.gray)
                            .frame(minWidth: 50, minHeight: 50)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                #endif
                
                Spacer()
                
                VStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: 120)
                        .shadow(color: .white.opacity(0.2), radius: 10)
                    
                    Text("Kase3D")
                        .font(.title)
                    
                    Text("Version: 0.2")
                        .font(.caption)
                }
                
                Spacer()
                
                VStack {
                    Button {
                        appCoordinator.appStore.isFileImporterPresented = true
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(WelcomeViewButtonStyle())
                    
                    Button {
                        appCoordinator.clearRecents()
                    } label: {
                        Label("Clear Recents", systemImage: "trash")
                    }
                    .buttonStyle(WelcomeViewButtonStyle())
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.thinMaterial)
            
            if !appCoordinator.recentsManager.recentBookmarks.isEmpty{
                ScrollView {
                    ForEach(appCoordinator.recentsManager.recentBookmarks) { bookmark in
                        Button {
                            Task { @MainActor in
                                try? await Task.sleep(for: .seconds(1))
                                
                                #if os(macOS)
                                appCoordinator.startAccessing(bookmark: bookmark) { url in
                                    openWindow(
                                        id: WindowKeys.editor.rawValue,
                                        value: FileInfo(
                                            fileName: bookmark.fileName,
                                            path: url
                                        )
                                    )
                                    dismissWindow(id: WindowKeys.welcome.rawValue)
                                }
                                #elseif os(iOS)
                                appCoordinator.openRecent(bookmark)
                                #endif
                            }
                        } label: {
                            Label(bookmark.fileName, systemImage: "document")
                        }
                        .buttonStyle(WelcomeViewButtonStyle())
                    }
                    .frame(alignment: .leading)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thickMaterial)
            } else {
                VStack {
                    Text("You don't have any recently opened models.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thickMaterial)
            }
        }
        #if os(macOS)
        .clipShape(.rect(cornerRadius: 16))
        #endif
        .fileImporter(
            isPresented: isFileImporterPresentedBinding,
            allowedContentTypes: [.usdz]) { result in
                switch result {
                case .success(let url):
                    Task { @MainActor in
                        let needsScopedAccess = url.startAccessingSecurityScopedResource()
                        defer {
                            if needsScopedAccess {
                                url.stopAccessingSecurityScopedResource()
                            }
                        }
                        appCoordinator.addRecentFile(url)
                        guard let latestRecent = appCoordinator.getLatestRecentFileBookmark(url.lastPathComponent) else { return }
                        let url = appCoordinator.recentsManager.resolveBookmark(latestRecent)
                        pendingURL = url
                        appCoordinator.appStore.isFileImporterPresented = false
                        
                        guard let pendingURL else { return }
                        try? await Task.sleep(for: .seconds(1))
                        
                        #if os(macOS)
                        openWindow(
                            id: WindowKeys.editor.rawValue,
                            value: FileInfo(
                                fileName: pendingURL.lastPathComponent,
                                path: pendingURL
                            )
                        )
                        dismissWindow(id: WindowKeys.welcome.rawValue)
                        #elseif os(iOS)
                        appCoordinator.loadModel(from: pendingURL)
                        #endif
                    }
                case .failure(let error):
                    let kaseError = ErrorManager.shared.map(error)
                    ErrorManager.shared.present(kaseError)
                }
            }
    }
}

#Preview {
    WelcomeView()
}
