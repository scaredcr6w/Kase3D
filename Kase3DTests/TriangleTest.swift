//
//  TriangleTest.swift
//  Kase3DTests
//
//  Created by Anda Levente on 2025. 11. 14..
//

import XCTest
@testable import Kase3D

final class TriangleTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTriangleVertexCount() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            do {
                try XCTSkipIf(true, "Metal device is not available in this environment")
            } catch {
                print("error skipping test")
            }
            return
        }
        
        let triangle = Triangle(device: device)
        XCTAssertEqual(triangle.vertices.count, 3)
        XCTAssertEqual(triangle.indices.count, 3)
    }

}
