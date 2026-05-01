//
//  AppCoordinator+UIStore.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 16..
//

import Foundation

extension AppCoordinator {
    func deselectPanel() {
        uiStore.panelCoordinator.deselect()
    }
}
