//
//  SideButtonColumnView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 04..
//

import SwiftUI

@MainActor
struct SideButtonActionOverlayPreferenceKey: PreferenceKey {
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

enum SideButton: CaseIterable, Hashable {
    case mesh
    case lighting
    
    var name: String {
        switch self {
        case .mesh:
            String(localized: "Meshes")
        case .lighting:
            String(localized: "Lighting")
        }
    }
    
    var symbol: String {
        switch self {
        case .mesh:
            "text.line.first.and.arrowtriangle.forward"
        case .lighting:
            "lightbulb"
        }
    }
}
