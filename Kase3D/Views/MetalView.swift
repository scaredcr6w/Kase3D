//
//  MetalView.swift
//  Kase3D
//
//  Created by Anda Levente on 2025. 11. 14..
//

import SwiftUI
import MetalKit
import Kase3DEngine

struct MetalView: View {
    @Environment(SceneManager.self) private var sceneManager: SceneManager
    @State private var metalView: MTKView = MTKView()
    @State private var modelController: ModelController?
    @State private var didError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView, controller: modelController)
            .onAppear {
                do {
                    modelController = try ModelController(sceneManager: sceneManager, metalView: metalView)
                } catch {
                    didError = true
                    errorMessage = error.localizedDescription
                }
            }
            .alert(
                "Error",
                isPresented: $didError) {
                    Button("Exit") {
                        didError = false
                        errorMessage = ""
                    }
                } message: {
                    Text(!errorMessage.isEmpty ? errorMessage : "An unexpected error occured")
                }

    }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var metalView: MTKView
    let controller: ModelController?
    
    #if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateMetalView()
    }
    
    #elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        updateMetalView()
    }
    #endif
    
    func updateMetalView() {
        
    }
}

#Preview {
    MetalView()
}
