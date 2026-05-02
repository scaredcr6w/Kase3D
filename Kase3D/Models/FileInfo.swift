//
//  FileInfo.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 04. 03..
//

import Foundation

struct FileInfo: Codable, Hashable {
    let fileName: String
    let path: URL
}
