//
//  RecentFilesManager.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import Foundation
import CryptoKit

struct RecentFileBookmark: Codable, Identifiable {
    var id: String
    let bookmarkData: Data
    let fileName: String
}

@Observable
final class RecentFilesManager {
    var recentBookmarks: [RecentFileBookmark] = []
    private let key = "recentFiles"
    
    init() {
        loadRecents()
    }
    
    func addRecentFile(_ url: URL) {
        do {
            guard FileManager.default.fileExists(atPath: url.path) else {
                print("File does not exist at path: \(url.path)")
                return
            }
            
            let bookmarkData = try bookmarkData(for: url)
            
            let hashedURL = hashURL(url.absoluteString)
            
            let bookmark = RecentFileBookmark(
                id: hashedURL,
                bookmarkData: bookmarkData,
                fileName: url.lastPathComponent
            )
            
            recentBookmarks.removeAll { $0.fileName == bookmark.fileName && $0.id == bookmark.id }
            recentBookmarks.insert(bookmark, at: 0)
            
            if recentBookmarks.count > 10 {
                recentBookmarks = Array(recentBookmarks.prefix(10))
            }
            
            saveRecentFiles()
        } catch {
            print("Failed to create bookmark: \(error.localizedDescription)")
            print("Error details: \(error)")
        }
    }
    
    func resolveBookmark(_ bookmark: RecentFileBookmark) -> URL? {
        do {
            var isStale = false
            let url = try resolveURL(for: bookmark.bookmarkData, isStale: &isStale)
            
            if isStale {
                addRecentFile(url)
            }
            
            return url
        } catch {
            print("Failed to resolve bookmark: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveRecentFiles() {
        do {
            let data = try JSONEncoder().encode(recentBookmarks)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save bookmarks: \(error.localizedDescription)")
        }
    }
    
    func loadRecents() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        
        do {
            recentBookmarks = try JSONDecoder().decode([RecentFileBookmark].self, from: data)
        } catch {
            print("Failed to load bookmarks: \(error.localizedDescription)")
        }
    }
    
    func clearRecents() {
        UserDefaults.standard.set(nil, forKey: key)
        recentBookmarks = []
        print("Bookmarks cleared")
    }
    
    func startAccessing(bookmark: RecentFileBookmark, _ completion: (URL) -> Void) {
        if let url = resolveBookmark(bookmark) {
            guard url.startAccessingSecurityScopedResource() else {
                print("Failed to access security-scoped resource")
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            completion(url)
        }
    }
    
    private func hashURL(_ urlString: String) -> String {
        let data = Data(urlString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    private func bookmarkData(for url: URL) throws -> Data {
        #if os(macOS)
        return try url.bookmarkData(
            options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        #elseif os(iOS)
        return try url.bookmarkData()
        #endif
    }
    
    private func resolveURL(for data: Data, isStale: inout Bool) throws -> URL {
        #if os(macOS)
        return try URL(
            resolvingBookmarkData: data,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        #elseif os(iOS)
        return try URL(
            resolvingBookmarkData: data,
            options: [],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        #endif
    }
}
