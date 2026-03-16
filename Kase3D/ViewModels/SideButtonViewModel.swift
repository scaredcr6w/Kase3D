//
//  SideButtonViewModel.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 03. 12..
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class SideButtonViewModel {
    var selected: SideButton? = nil
    
    func binding(for button: SideButton) -> Binding<Bool> {
        Binding(
            get: { self.selected == button },
            set: { isOn in
                if isOn {
                    self.selected = button
                } else {
                    if self.selected == button {
                        self.selected = nil
                    }
                }
            }
        )
    }
}
