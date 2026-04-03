//
//  DirectionLineProperties.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 04. 03..
//

import Foundation

struct DirectionLineProperties: Identifiable {
    let id = UUID()
    var isVisible: Bool = true
    var lineThickness: Float = 0.02
    let minimumLineThickness: Float = 0.002
    let maximumLineThickness: Float = 0.02
}
