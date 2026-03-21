//
//  SubmeshDescriptor.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 03. 21..
//

import Foundation

@Observable
public final class SubmeshDescriptor: Identifiable {
    public let id = UUID()
    private let submesh: Submesh
    
    public var submeshName: String {
        submesh.submeshProperties.submeshName
    }
    
    public var isVisible: Bool
    
    init(submesh: Submesh) {
        self.submesh = submesh
        self.isVisible = submesh.submeshProperties.isVisible
    }
    
    public func toggleVisibility() {
        submesh.submeshProperties.isVisible.toggle()
        isVisible = submesh.submeshProperties.isVisible
    }
}
