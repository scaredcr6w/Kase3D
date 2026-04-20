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
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(minWidth: 50, minHeight: 50)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                #endif
                
                Spacer()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.black.gradient)
                            .shadow(color: .white.opacity(0.2), radius: 10)
                        
                        Image("kase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 120, height: 120)
                    
                    Text(verbatim: "Kase3D")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    if let versionNumber = Bundle.main.versionNumber {
                        Text("Version: \(versionNumber)")
                            .font(.caption)
                    }
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
            
            Divider()
                .background(Color.white.opacity(0.15))
                .padding(.vertical)
            
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
            } else {
                VStack {
                    Text("You don't have any recently opened models.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .compositingGroup()
        .background(.thinMaterial)
        #if os(macOS)
        .clipShape(.rect(cornerRadius: 24))
        #endif
        .fileImporter(
            isPresented: isFileImporterPresentedBinding,
            allowedContentTypes: [.usdz]) { result in
                switch result {
                case .success(let url):
                    Task { @MainActor in
                        guard url.startAccessingSecurityScopedResource() else {
                            ErrorManager.shared.present(FileError.accessError)
                            return
                        }
                        defer { url.stopAccessingSecurityScopedResource() }
                        
                        appCoordinator.addRecentFile(url)
                        guard let latestRecent = appCoordinator.getLatestRecentFileBookmark(url.lastPathComponent),
                              let resolvedURL = appCoordinator.recentsManager.resolveBookmark(latestRecent) else { return }
                        
                        appCoordinator.appStore.isFileImporterPresented = false
                        
                        try? await Task.sleep(for: .seconds(1))
                        
                        #if os(macOS)
                        openWindow(
                            id: WindowKeys.editor.rawValue,
                            value: FileInfo(
                                fileName: resolvedURL.lastPathComponent,
                                path: resolvedURL
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
