//
//  SideButtonColumnView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 04..
//

import SwiftUI

@MainActor
private struct SideButtonActionOverlayPreferenceKey: PreferenceKey {
    struct Item: Identifiable {
        let id: UUID
        let anchor: Anchor<CGRect>
        let view: AnyView
        let isOn: Bool
    }

    static var defaultValue: [Item] = []

    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

struct SideButtonColumnView<Content:View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            content
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlayPreferenceValue(SideButtonActionOverlayPreferenceKey.self) { items in
            GeometryReader { proxy in
                ZStack(alignment: .topLeading) {
                    ForEach(items) { item in
                        if item.isOn {
                            item.view
                                .offset(x: proxy[item.anchor].minX, y: proxy[item.anchor].minY)
                                .fixedSize(horizontal: false, vertical: true)
                                .transition(.offset(x: -8).combined(with: .opacity))
                                .animation(.easeOut(duration: 0.2), value: item.isOn)
                        }
                    }
                }
            }
        }
    }
}

// TODO: When a button is selected, and another hovered, the selected button's actions should be hidden to show the hovered one's actionLabel
struct SideButtonView<Content: View, Label: View, Action: View>: View {
    @Binding var isOn: Bool
    @ViewBuilder var content: Content
    @ViewBuilder var contentLabel: Label
    @ViewBuilder var action: Action
    
    @State private var isHovering: Bool = false
    
    private let id = UUID()
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    isOn.toggle()
                }
            } label: {
                content
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    .contentShape(Circle())
                    .labelStyle(.iconOnly)
                    .labelsHidden()
            }
            .buttonStyle(.plain)
            .glassEffect(
                isOn
                ? .regular.tint(.blue.opacity(0.7)).interactive()
                : .regular.tint(.white.opacity(0.3)).interactive()
            )
            .onHover { hover in
                withAnimation(.easeOut(duration: 0.2)) {
                    isHovering = hover
                }
            }
            
            ZStack(alignment: .leading) {
                contentLabel
                    .font(.system(size: 12))
                    .padding(6)
                    .glassEffect(.regular.tint(.white.opacity(0.3)), in: .rect(cornerRadius: 6))
                    .opacity((isHovering && !isOn) ? 1 : 0)
                    .offset(x: (isHovering && !isOn) ? 0 : -8)
                    .labelStyle(.titleOnly)
            }
            .anchorPreference(key: SideButtonActionOverlayPreferenceKey.self, value: .bounds) { anchor in
                let actionView: AnyView = AnyView(
                    action
                        .font(.system(size: 12))
                        .padding(6)
                        .glassEffect(.regular.tint(.white.opacity(0.3)), in: .rect(cornerRadius: 6))
                        .labelStyle(.titleOnly)
                )
                return [SideButtonActionOverlayPreferenceKey.Item(id: id, anchor: anchor, view: actionView, isOn: isOn)]
            }
            .animation(.easeOut(duration: 0.2), value: isHovering)
            .animation(.easeOut(duration: 0.2), value: isOn)
            .frame(maxWidth: .infinity, alignment: .leading)
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
