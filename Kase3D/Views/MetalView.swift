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
        inputController?.onPanChanged(
            x: Float(event.scrollingDeltaX),
            y: Float(event.scrollingDeltaY)
        )
    }
    
    override func magnify(with event: NSEvent) {
        super.magnify(with: event)
        inputController?.onMagnificationChanged(
            event.magnification
        )
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        inputController?.onDragChanged(
            x: Float(event.deltaX),
            y: Float(event.deltaY)
        )
    }
}
#elseif os(iOS)
import UIKit
final class CustomMTKView: MTKView {
    weak var inputController: (any InputProviding)?

    private var previousDrag: CGPoint = .zero
    private var previousMagnification: CGFloat = 1
    private var previousPan: CGPoint = .zero

    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gr.minimumNumberOfTouches = 2
        gr.maximumNumberOfTouches = 2
        return gr
    }()
    
    private lazy var dragRecognizer: UIPanGestureRecognizer = {
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        gr.maximumNumberOfTouches = 1
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
        panRecognizer.delegate = self
        dragRecognizer.delegate = self
        pinchRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(pinchRecognizer)
        addGestureRecognizer(dragRecognizer)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let dx = Float(translation.x - previousPan.x)
        let dy = Float(translation.y - previousPan.y)
        inputController?.onPanChanged(
            x: dx,
            y: dy
        )
        previousPan = translation
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            previousPan = .zero
        }
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        let deadzone: CGFloat = 0.04
        let velocityThreshold: CGFloat = 0.15

        let delta = abs(gesture.scale - 1.0)
        let velocity = abs(gesture.velocity)

        if delta < deadzone && velocity < velocityThreshold {
            if gesture.state == .ended || gesture.state == .cancelled {
                previousMagnification = 1
            } else {
                previousMagnification = gesture.scale
            }
            return
        }
        
        let magnification = gesture.scale - previousMagnification
        
        inputController?.onMagnificationChanged(magnification)
        previousMagnification = gesture.scale
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            previousMagnification = 1
        }
    }
    
    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let dx = Float(translation.x - previousDrag.x)
        let dy = Float(translation.y - previousDrag.y)
        inputController?.onDragChanged(
            x: dx,
            y: dy
        )
        previousDrag = translation
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            previousDrag = .zero
        }
    }
}

extension CustomMTKView: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        let isDragAndPan = (gestureRecognizer === dragRecognizer && otherGestureRecognizer === panRecognizer) ||
                           (gestureRecognizer === panRecognizer && otherGestureRecognizer === dragRecognizer)
        
        let involvesPinch = (gestureRecognizer === pinchRecognizer) || (otherGestureRecognizer === pinchRecognizer)
        return isDragAndPan && !involvesPinch
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
