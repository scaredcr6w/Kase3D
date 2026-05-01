//
//  PanelRegistry.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 17..
//

import Foundation

@Observable
@MainActor
final class PanelRegistry {
    private(set) var panels: [any PanelProvider] = []
    
    func register(_ panel: any PanelProvider) {
        guard !panels.contains(where: { registered in
            registered.button == panel.button
        }) else { return }
        
        panels.append(panel)
    }
    
    func panel(for button: SideButton) -> (any PanelProvider)? {
        return panels.first { panel in
            panel.button == button
        }
    }
}
