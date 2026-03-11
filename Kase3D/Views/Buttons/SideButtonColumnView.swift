//
//  SideButtonColumnView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 04..
//

import SwiftUI

struct SideButtonColumnView: View {
    @State private var selectedButton: SideButton? = nil // TODO: Move buttons to superview, so they can be passed in via a viewbuilder function
    @State private var hoveredButton: SideButton? = nil
    let labelWidth: CGFloat = 90
    
    var body: some View {
        GlassEffectContainer(spacing: 10) {
            VStack(spacing: 20) {
                
                // TODO: When a button is selected, other buttons should sift downwards to make space for the selected button's sub items
                ForEach(SideButton.allCases, id: \.hashValue) { button in
                    HStack (spacing: 10) {
                        Image(systemName: button.symbol)
                            .frame(width: 50, height: 50)
                            .font(.system(size: 20))
                            .selectedGlass(button, selected: selectedButton, hovered: hoveredButton)
                            .contentShape(Circle())
                            .onTapGesture {
                                selectedButton = button
                            }
                            .onHover { isHovering in
                                hoveredButton = isHovering ? button : nil
                            }
                        
                        ZStack(alignment: .leading) {
                            if hoveredButton == button {
                                Text(button.rawValue)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12))
                                    .padding(6)
                                    .glassEffect(.regular.tint(.white.opacity(0.3)), in: .rect(cornerRadius: 6))
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                            } else {
                                Text(button.rawValue)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12))
                                    .padding(4)
                                    .hidden()
                            }
                        }
                        .frame(width: labelWidth)
                    }
                    .animation(.easeOut(duration: 0.2), value: hoveredButton == button)
                }
                .compositingGroup()
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
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

extension View {
    @ViewBuilder
    func selectedGlass(_ button: SideButton, selected: SideButton?, hovered: SideButton?) -> some View {
        if let selected, selected == button  {
            self
                .glassEffect(.regular.tint(.blue.opacity(0.7)).interactive())
        } else if let hovered, hovered == button{
            self
                .glassEffect(.regular.tint(.white.opacity(0.3)).interactive())
        } else {
            self
                .glassEffect()
        }
    }
}

#Preview {
    SideButtonColumnView()
}
