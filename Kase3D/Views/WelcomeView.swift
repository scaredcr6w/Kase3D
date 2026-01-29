//
//  WelcomeView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import SwiftUI

struct WelcomeView: View {
    @Environment(RecentFilesManager.self) private var recentsManager
    
    var body: some View {
        Grid {
            GridRow {
                ForEach(recentsManager.recentBookmarks, id: \.fileName) { bookmark in
                    ModelButtonView(bookmark: bookmark)
                }
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    WelcomeView()
}
