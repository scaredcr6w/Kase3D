//
//  PanelProvider.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import SwiftUI

@MainActor
protocol PanelProvider: AnyObject {
    var button: SideButton { get }
    func content() -> AnyView
}
