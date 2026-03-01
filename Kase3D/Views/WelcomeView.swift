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
        VStack(alignment: .leading) {
            Text("Recently Opened Models")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding([.top, .leading], 32)
            
            Divider()
            
            if recentsManager.recentBookmarks.isEmpty {
                VStack {
                    Text("You don't have any recently opened models.")
                        .font(.system(size: 32))
                        .foregroundStyle(Color(nsColor: .lightGray))
                        .padding([.top, .leading], 32)
                }
            }
            
            Grid {
                ScrollView(.horizontal) {
                    GridRow {
                        ForEach(recentsManager.recentBookmarks) { bookmark in
                            ModelButtonView(bookmark: bookmark)
                        }
                    }
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
}

#Preview {
    WelcomeView()
}
