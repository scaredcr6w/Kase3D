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
    @Environment(AppCoordinator.self) private var appCoordinator
    @State private var metalView: CustomMTKView = CustomMTKView()
    @State private var modelController: ModelController?
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView, controller: modelController)
            .onAppear {
                modelController = ModelController(sceneManager: appCoordinator.sceneManager, metalView: metalView)
                metalView.inputController = modelController?.inputController
            }
    }
}

#if os(macOS)
import AppKit
final class CustomMTKView: MTKView {
    weak var inputController: (any InputProviding)?

    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        inputController?.mousePan = float2(Float(event.scrollingDeltaX), Float(event.scrollingDeltaY))
    }
    
    override func magnify(with event: NSEvent) {
        super.magnify(with: event)
        inputController?.onMagnificationChanged(event.magnification)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        let delta = CGSize(width: Double(event.deltaX), height: Double(event.deltaY))
        inputController?.onDragChanged(delta)
    }
}
#elseif os(iOS) // TODO: validate in iPadOS support ticket
import UIKit
final class CustomMTKView: MTKView {
    weak var inputController: (any InputProviding)?

    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gr.maximumNumberOfTouches = 2
        return gr
    }()

    private lazy var pinchRecognizer: UIPinchGestureRecognizer = {
        let gr = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        return gr
    }()

    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        isMultipleTouchEnabled = true
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(pinchRecognizer)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        inputController?.onDragChanged(CGSize(width: translation.x, height: translation.y))
        if gesture.state == .ended || gesture.state == .cancelled {
            inputController?.onDragEnded()
        }
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        inputController?.onMagnificationChanged(gesture.scale)
        if gesture.state == .ended || gesture.state == .cancelled {
            inputController?.onMagnificationEnded()
        }
    }
}
#endif

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var metalView: CustomMTKView
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
