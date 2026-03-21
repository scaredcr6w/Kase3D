//
//  SideButtonStaticView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 21..
//

import SwiftUI

struct SideButtonStaticView<Content: View, Label: View>: View {
    @ViewBuilder var content: Content
    @ViewBuilder var contentLabel: Label
    var action: () -> Void
    
    @Environment(AppCoordinator.self) private var appCoordinator
    
    @State private var isHovering: Bool = false
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                content
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .glassEffect(
                .regular.tint(.white.opacity(0.3))
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
                    .opacity((isHovering && appCoordinator.uiStore.panelCoordinator.selected == nil) ? 1 : 0)
                    .offset(x: isHovering ? 0 : -8)
            }
            .animation(.easeOut(duration: 0.2), value: isHovering)
        }
        .compositingGroup()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
