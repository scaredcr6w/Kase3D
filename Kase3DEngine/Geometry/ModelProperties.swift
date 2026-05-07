//
//  ModelProperties.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 05. 02..
//

import Foundation
import Combine

public struct ModelProperties: Identifiable {
    public var id = UUID()
    public var name: String = "Untitled"
    public var isSelected = CurrentValueSubject<Bool, Never>(false)
}
