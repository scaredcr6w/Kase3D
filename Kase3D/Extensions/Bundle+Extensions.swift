//
//  Bundle+Extensions.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 20..
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
