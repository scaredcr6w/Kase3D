//
//  MatrixTests.swift
//  Kase3DTests
//
//  Created by Anda Levente on 2025. 11. 14..
//

import XCTest
@testable import Kase3D

final class MatrixTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProjectionMatrix() {
        let matrix = Matrix.projectionMatrix(aspectRatio: 16/9)
        XCTAssertNotEqual(matrix[0, 0], matrix[1, 1])
    }
}
