//
//  TransformTests.swift
//  Kase3DTests
//
//  Created by Anda Levente on 2025. 11. 14..
//

import XCTest
@testable import Kase3D

final class TransformTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIdentityModelMatrix() {
        let transform = Transform()
        let matrix = transform.modelMatrix
        XCTAssertEqual(matrix, matrix_identity_float4x4)
    }
    
    func testTranslationMatrix() {
        var transform = Transform()
        transform.position = [1, 2, 3]
        let matrix = transform.modelMatrix
        XCTAssertEqual(matrix[3, 0], 1)
        XCTAssertEqual(matrix[3, 1], 2)
        XCTAssertEqual(matrix[3, 2], 3)
    }
}
