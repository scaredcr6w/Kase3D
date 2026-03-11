//
//  SideButtonColumnView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 04..
//

import SwiftUI

struct SideButtonColumnView<Content:View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GlassToggleStyle: ToggleStyle {
    @State private var isHovering: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                configuration.label
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    .contentShape(Circle())
                    .labelStyle(.iconOnly)
                    .labelsHidden()
            }
            .buttonStyle(.plain)
            .glassEffect(
                configuration.isOn
                ? .regular.tint(.blue.opacity(0.7)).interactive()
                : .regular.tint(.white.opacity(0.3)).interactive()
            )
            .onHover { hover in
                isHovering = hover
            }
            
            ZStack(alignment: .leading) {
                configuration.label
                    .font(.system(size: 12))
                    .padding(6)
                    .glassEffect(.regular.tint(.white.opacity(0.3)), in: .rect(cornerRadius: 6))
                    .opacity((isHovering && !configuration.isOn) ? 1 : 0)
                    .offset(x: (isHovering && !configuration.isOn) ? 0 : -8)
                    .labelStyle(.titleOnly)
            }
            .frame(width: 90, alignment: .leading)
            .animation(.easeOut(duration: 0.2), value: isHovering)
            .animation(.easeOut(duration: 0.2), value: configuration.isOn)
        }
        .compositingGroup()
    }
}

enum SideButton: String, CaseIterable {
    case mesh = "Meshes"
    case lighting = "Lighting"
    
    var symbol: String {
        switch self {
        case .mesh:
            "text.line.first.and.arrowtriangle.forward"
        case .lighting:
            "lightbulb"
        }
    }
}
