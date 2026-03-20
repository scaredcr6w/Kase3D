//
//  CustomDisclosureGroup.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 20..
//

import SwiftUI

struct CustomDisclosureGroup: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.right")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .rotationEffect(configuration.isExpanded ? Angle(degrees: 90) : Angle(degrees: 0))
                    configuration.label
                        .font(.callout)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if configuration.isExpanded {
                configuration.content
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.top, 0.008)
            }
        }
    }
}
