//
//  WelcomeView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 01. 29..
//

import SwiftUI

struct WelcomeView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    
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
            } else {
                VStack {
                    Text("You don't have any recently opened models.")
                        .font(.title)
                        .foregroundStyle(Color(nsColor: .lightGray))
                    
                    Text("Import files with ⌘I")
                        .font(.title2)
                        .foregroundStyle(Color(nsColor: .lightGray))
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
}

#Preview {
    WelcomeView()
}
