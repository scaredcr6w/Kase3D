//
//  TransformTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 02. 14..
//

import XCTest
@testable import Kase3DEngine

final class TransformTests: XCTestCase {
    
    // MARK: - Transform Initialization Tests
    
    func testTransformDefaultInitialization() {
        let transform = Transform()
        
        XCTAssertEqual(transform.position, float3(0, 0, 0))
        XCTAssertEqual(transform.rotation, float3(0, 0, 0))
        XCTAssertEqual(transform.scale, 0.5)
    }
    
    func testTransformCustomInitialization() {
        var transform = Transform()
        transform.position = float3(1, 2, 3)
        transform.rotation = float3(0.5, 1.0, 1.5)
        transform.scale = 2.0
        
        XCTAssertEqual(transform.position, float3(1, 2, 3))
        XCTAssertEqual(transform.rotation, float3(0.5, 1.0, 1.5))
        XCTAssertEqual(transform.scale, 2.0)
    }
    
    // MARK: - Model Matrix Tests
    
    func testModelMatrixWithDefaultTransform() {
        let transform = Transform()
        let modelMatrix = transform.modelMatrix
        
        XCTAssertNotEqual(modelMatrix, float4x4.identity)
    }
    
    func testModelMatrixWithIdentityTransform() {
        var transform = Transform()
        transform.position = float3(0, 0, 0)
        transform.rotation = float3(0, 0, 0)
        transform.scale = 1.0
        
        let modelMatrix = transform.modelMatrix
        
        XCTAssertEqual(modelMatrix.columns.0.x, 1, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.1.y, 1, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.2.z, 1, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.3.w, 1, accuracy: 0.001)
    }
    
    func testModelMatrixWithTranslationOnly() {
        var transform = Transform()
        transform.position = float3(5, 10, 15)
        transform.rotation = float3(0, 0, 0)
        transform.scale = 1.0
        
        let modelMatrix = transform.modelMatrix
        
        XCTAssertEqual(modelMatrix.columns.3.x, 5, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.3.y, 10, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.3.z, 15, accuracy: 0.001)
    }
    
    func testModelMatrixWithScaleOnly() {
        var transform = Transform()
        transform.position = float3(0, 0, 0)
        transform.rotation = float3(0, 0, 0)
        transform.scale = 2.0
        
        let modelMatrix = transform.modelMatrix
        
        XCTAssertEqual(modelMatrix.columns.3.w, 0.5, accuracy: 0.001)
    }
    
    func testModelMatrixWithRotationOnly() {
        var transform = Transform()
        transform.position = float3(0, 0, 0)
        transform.rotation = float3(Float.pi / 2, 0, 0)
        transform.scale = 1.0
        
        let modelMatrix = transform.modelMatrix
        
        XCTAssertNotEqual(modelMatrix, float4x4.identity)
        
        XCTAssertEqual(modelMatrix.columns.1.y, 0, accuracy: 0.001)
        XCTAssertGreaterThan(abs(modelMatrix.columns.1.z), 0.9)
    }
    
    func testModelMatrixChangesWithPosition() {
        var transform = Transform()
        transform.scale = 1.0
        transform.rotation = float3(0, 0, 0)
        
        transform.position = float3(1, 0, 0)
        let matrix1 = transform.modelMatrix
        
        transform.position = float3(0, 1, 0)
        let matrix2 = transform.modelMatrix
        
        XCTAssertNotEqual(matrix1, matrix2)
    }
    
    // MARK: - Transformable Protocol Tests
    
    func testTransformableProtocolPosition() {
        var mock = MockTransformable()
        
        mock.position = float3(5, 10, 15)
        
        XCTAssertEqual(mock.position, float3(5, 10, 15))
        XCTAssertEqual(mock.transform.position, float3(5, 10, 15))
    }
    
    func testTransformableProtocolRotation() {
        var mock = MockTransformable()
        
        mock.rotation = float3(0.5, 1.0, 1.5)
        
        XCTAssertEqual(mock.rotation, float3(0.5, 1.0, 1.5))
        XCTAssertEqual(mock.transform.rotation, float3(0.5, 1.0, 1.5))
    }
    
    func testTransformableProtocolScale() {
        var mock = MockTransformable()
        
        mock.scale = 3.0
        
        XCTAssertEqual(mock.scale, 3.0)
        XCTAssertEqual(mock.transform.scale, 3.0)
    }
    
    func testTransformableProtocolGettersAndSetters() {
        var mock = MockTransformable()
        
        mock.position = float3(1, 2, 3)
        mock.rotation = float3(0.1, 0.2, 0.3)
        mock.scale = 2.5
        
        XCTAssertEqual(mock.position, float3(1, 2, 3))
        XCTAssertEqual(mock.rotation, float3(0.1, 0.2, 0.3))
        XCTAssertEqual(mock.scale, 2.5)
        
        XCTAssertEqual(mock.transform.position, float3(1, 2, 3))
        XCTAssertEqual(mock.transform.rotation, float3(0.1, 0.2, 0.3))
        XCTAssertEqual(mock.transform.scale, 2.5)
    }
    
    func testTransformableProtocolModifiesUnderlyingTransform() {
        var mock = MockTransformable()
        
        mock.position = float3(10, 20, 30)
        
        XCTAssertEqual(mock.transform.position.x, 10)
        XCTAssertEqual(mock.transform.position.y, 20)
        XCTAssertEqual(mock.transform.position.z, 30)
    }
    
    
    struct MockTransformable: Transformable {
        var transform: Transform = .init()
    }
}
