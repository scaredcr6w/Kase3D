//
//  SideButtonExpandingView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 21..
//

import SwiftUI

struct SideButtonExpandingView<Content: View, Label: View, Action: View>: View {
    @Binding var isOn: Bool
    @ViewBuilder var content: Content
    @ViewBuilder var contentLabel: Label
    @ViewBuilder var action: Action
    
    @Environment(AppCoordinator.self) private var appCoordinator
    
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
            }
            .buttonStyle(.plain)
            .glassEffect(
                isOn
                ? .regular.tint(.blue).interactive()
                : .regular.tint(.white.opacity(0.1)).interactive()
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
                    .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 6))
                    .opacity((isHovering && !isOn && appCoordinator.uiStore.panelCoordinator.selected == nil) ? 1 : 0)
                    .offset(x: (isHovering && !isOn) ? 0 : -8)
            }
            .animation(.easeOut(duration: 0.2), value: isHovering)
            .animation(.easeOut(duration: 0.2), value: isOn)
        }
        .compositingGroup()
        .frame(maxWidth: .infinity, alignment: .leading)
        .anchorPreference(key: SideButtonActionOverlayPreferenceKey.self, value: .bounds) { anchor in
            let actionView: AnyView = AnyView(
                ZStack {
                    action
                        .font(.system(size: 12))
                        .padding(6)
                        .frame(width: trailingPanelWidth)
                }
                .frame(maxHeight: .infinity)
            )
            return [SideButtonActionOverlayPreferenceKey.Item(id: id, anchor: anchor, view: actionView, isOn: isOn)]
        }
    }
}
