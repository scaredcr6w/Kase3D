//
//  ContentView.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI
import Kase3DEngine

struct ContentView: View {
    @Environment(SceneManager.self) private var sceneManager
    
    var body: some View {
        ZStack {
            MetalView()
            if !sceneManager.hasLoadedAnyModel {
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
