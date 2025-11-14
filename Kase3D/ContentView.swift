//
//  ContentView.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            Text("toolPlaceholder")
        } detail: {
            MetalView()
        }

    }
}

#Preview {
    ContentView()
}
