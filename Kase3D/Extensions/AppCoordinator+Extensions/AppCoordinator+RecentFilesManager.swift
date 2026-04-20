//
//  AppCoordinator+RecentFilesManager.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 16..
//

import Foundation
import Kase3DEngine

extension AppCoordinator {
    func openRecent(_ bookmark: RecentFileBookmark) {
        recentsManager.startAccessing(bookmark: bookmark, sceneManager.loadModel(from:))
    }
    
    func startAccessing(bookmark: RecentFileBookmark, completion: (URL) -> Void) {
        recentsManager.startAccessing(bookmark: bookmark, completion)
    }
    
    func addRecentFile(_ url: URL) {
        recentsManager.addRecentFile(url)
    }
    
    func getLatestRecentFileBookmark(_ lastPathComponent: String) -> RecentFileBookmark? {
        return recentsManager.recentBookmarks.first { bookmark in
            bookmark.fileName == lastPathComponent
        }
    }
    
    func clearRecents() {
        recentsManager.clearRecents()
    }
}
