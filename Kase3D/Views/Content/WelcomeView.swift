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
        VStack(alignment: .leading) {
            if !appCoordinator.recentsManager.recentBookmarks.isEmpty {
                Text("Recently Opened Models")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding([.top, .leading], 32)
                
                Divider()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(appCoordinator.recentsManager.recentBookmarks) { bookmark in
                            ModelButtonView(bookmark: bookmark)
                        }
                    }
                }
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                HStack {
                    #if os(iOS)
                    Button("Import") {
                        appCoordinator.appStore.isFileImporterPresented = true
                    }
                    .foregroundStyle(.blue)
                    .buttonStyle(.glass)
                    .padding()
                    #endif
                    
                    Spacer()
                    
                    Button("Clear Recents") {
                        appCoordinator.clearRecents()
                    }
                    .buttonStyle(.glass)
                    .padding()
                }
                
            } else {
                VStack {
                    Text("You don't have any recently opened models.")
                        .font(.title)
                        .foregroundStyle(Color.lightGrey)

                    Button("Import") {
                        appCoordinator.appStore.isFileImporterPresented = true
                    }
                    .buttonStyle(.glass)
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .onChange(of: appCoordinator.appStore.isFileImporterPresented) { _, newValue in
            guard !newValue, let pendingURL else { return }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1))
                
                openWindow(
                    id: WindowKeys.editor.rawValue,
                    value: FileInfo(
                        fileName: pendingURL.lastPathComponent,
                        path: pendingURL
                    )
                )
                dismissWindow(id: WindowKeys.welcome.rawValue)
            }
        }
        .fileImporter(
            isPresented: isFileImporterPresentedBinding,
            allowedContentTypes: [.usdz]) { result in
                switch result {
                case .success(let url):
                    let needsScopedAccess = url.startAccessingSecurityScopedResource()
                    defer {
                        if needsScopedAccess {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }
                    appCoordinator.addRecentFile(url)
                    pendingURL = url
                    appCoordinator.appStore.isFileImporterPresented = false
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
