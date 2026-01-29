//
//  RecentFilesManager.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import Foundation

struct RecentFileBookmark: Codable {
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
            
            let bookmarkData = try url.bookmarkData(
                options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            let bookmark = RecentFileBookmark(
                bookmarkData: bookmarkData,
                fileName: url.lastPathComponent
            )
            
            recentBookmarks.removeAll { $0.fileName == bookmark.fileName }
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
            let url = try URL(
                resolvingBookmarkData: bookmark.bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
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
}
