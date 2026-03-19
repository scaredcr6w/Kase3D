//
//  Color+Extensions.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 19..
//

import SwiftUI

extension Color {
    static var lightGrey: Color {
        #if os(macOS)
        Color(nsColor: .lightGray)
        #elseif os(iOS)
        Color(uiColor: .lightGray)
        #endif
    }
}
