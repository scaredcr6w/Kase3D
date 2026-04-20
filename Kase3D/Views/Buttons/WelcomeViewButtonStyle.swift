//
//  WelcomeViewButtonStyle.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 20..
//

import SwiftUI

struct WelcomeViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? .gray : .white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .buttonStyle(.plain)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(configuration.isPressed ? .thinMaterial : .ultraThinMaterial)
            }
            .compositingGroup()
    }
}
