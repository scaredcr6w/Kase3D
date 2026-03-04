//
//  MathLibraryTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 02. 14..
//

import XCTest
@testable import Kase3DEngine

final class MathLibraryTests: XCTestCase {
    // MARK: Float extension tests
    func testToDegreesConvertsRadiansToDegrees() {
        XCTAssertEqual(Float.pi.toDegrees, 180.0, accuracy: 0.001)
        XCTAssertEqual((Float.pi / 2).toDegrees, 90.0, accuracy: 0.001)
        XCTAssertEqual((Float.pi / 4).toDegrees, 45.0, accuracy: 0.001)
        XCTAssertEqual((2 * Float.pi).toDegrees, 360.0, accuracy: 0.001)
        XCTAssertEqual(Float(0).toDegrees, 0.0, accuracy: 0.001)
    }
    
    func testToRadiansConvertsDegreesToRadians() {
        XCTAssertEqual(Float(180).toRadians, .pi, accuracy: 0.001)
        XCTAssertEqual(Float(90).toRadians, (.pi / 2), accuracy: 0.001)
        XCTAssertEqual(Float(45).toRadians, (.pi / 4), accuracy: 0.001)
        XCTAssertEqual(Float(360).toRadians, (.pi * 2), accuracy: 0.001)
        XCTAssertEqual(Float(0).toRadians, (0), accuracy: 0.001)
    }
    
    // MARK: float4x4 extension tests
    func testFloat4x4InitWithTranslation() {
        let translation = float3(1, 2, 3)
        let matrix = float4x4(translation: translation)
        XCTAssertEqual(matrix.upperLeft, matrix_identity_float3x3)
        XCTAssertEqual(matrix.columns.3, float4(translation, 1))
    }
    
    func testFloat4x4InitWithScaling() {
        let scaling = float3(1, 2, 3)
        let matrix = float4x4(scaling: scaling)
        XCTAssertEqual(matrix.columns.0.x, scaling.x)
        XCTAssertEqual(matrix.columns.0.y, 0)
        XCTAssertEqual(matrix.columns.0.z, 0)
        XCTAssertEqual(matrix.columns.1.x, 0)
        XCTAssertEqual(matrix.columns.1.y, scaling.y)
        XCTAssertEqual(matrix.columns.1.z, 0)
        XCTAssertEqual(matrix.columns.2.x, 0)
        XCTAssertEqual(matrix.columns.2.y, 0)
        XCTAssertEqual(matrix.columns.2.z, scaling.z)
    }
    
    // MARK: Projection Matrix Tests
    
    func testFloat4x4InitWithProjectionFov() {
        let fov = Float(70).toRadians
        let near: Float = 0.1
        let far: Float = 100
        let aspect: Float = 16.0 / 9.0
        
        let matrix = float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
        
        XCTAssertNotEqual(matrix, float4x4.identity)
        
        
        XCTAssertNotEqual(matrix.columns.0.x, 0)
        XCTAssertNotEqual(matrix.columns.1.y, 0)
        XCTAssertNotEqual(matrix.columns.2.z, 0)
        
        let expectedY = 1 / tan(fov * 0.5)
        XCTAssertEqual(matrix.columns.1.y, expectedY, accuracy: 0.001)
        
        let expectedX = expectedY / aspect
        XCTAssertEqual(matrix.columns.0.x, expectedX, accuracy: 0.001)
    }
    
    func testFloat4x4ProjectionFovLeftHandedVsRightHanded() {
        let fov = Float(60).toRadians
        let near: Float = 0.1
        let far: Float = 100
        let aspect: Float = 1.0
        
        let lhsMatrix = float4x4(projectionFov: fov, near: near, far: far, aspect: aspect, lhs: true)
        let rhsMatrix = float4x4(projectionFov: fov, near: near, far: far, aspect: aspect, lhs: false)
        
        XCTAssertNotEqual(lhsMatrix, rhsMatrix)
        
        XCTAssertEqual(lhsMatrix.columns.0.x, rhsMatrix.columns.0.x, accuracy: 0.001)
        XCTAssertEqual(lhsMatrix.columns.1.y, rhsMatrix.columns.1.y, accuracy: 0.001)
        
        XCTAssertNotEqual(lhsMatrix.columns.2.z, rhsMatrix.columns.2.z, accuracy: 0.001)
    }
    
    func testFloat4x4ProjectionFovChangingAspectRatio() {
        let fov = Float(70).toRadians
        let near: Float = 0.1
        let far: Float = 100
        
        let squareMatrix = float4x4(projectionFov: fov, near: near, far: far, aspect: 1.0)
        let wideMatrix = float4x4(projectionFov: fov, near: near, far: far, aspect: 16.0 / 9.0)
        
        XCTAssertNotEqual(squareMatrix.columns.0.x, wideMatrix.columns.0.x)
        
        XCTAssertEqual(squareMatrix.columns.1.y, wideMatrix.columns.1.y, accuracy: 0.001)
    }
    
    // MARK: LookAt Matrix Tests
    
    func testFloat4x4InitWithLookAt() {
        let eye = float3(0, 0, 5)
        let center = float3(0, 0, 0)
        let up = float3(0, 1, 0)
        
        let matrix = float4x4(eye: eye, center: center, up: up)
        
        XCTAssertNotEqual(matrix, float4x4.identity)

        let upperLeft = matrix.upperLeft
        XCTAssertNotEqual(upperLeft, matrix_identity_float3x3)
    }
    
    func testFloat4x4LookAtFromDifferentPositions() {
        let center = float3(0, 0, 0)
        let up = float3(0, 1, 0)
        
        let matrix1 = float4x4(eye: float3(0, 0, 5), center: center, up: up)
        let matrix2 = float4x4(eye: float3(5, 0, 0), center: center, up: up)
        
        XCTAssertNotEqual(matrix1, matrix2)
    }
    
    func testFloat4x4LookAtWithSameEyeAndCenter() {
        let position = float3(1, 2, 3)
        let up = float3(0, 1, 0)
        
        let matrix = float4x4(eye: position, center: position, up: up)
        
        XCTAssertNotNil(matrix)
    }
    
    func testFloat4x4LookAtForwardVector() {
        let eye = float3(0, 0, 10)
        let center = float3(0, 0, 0)
        let up = float3(0, 1, 0)
        
        let matrix = float4x4(eye: eye, center: center, up: up)
        
        let forward = normalize(center - eye)
        XCTAssertEqual(matrix.columns.2.x, forward.x, accuracy: 0.001)
        XCTAssertEqual(matrix.columns.2.y, forward.y, accuracy: 0.001)
        XCTAssertEqual(matrix.columns.2.z, forward.z, accuracy: 0.001)
    }
    
    // MARK: Orthographic Matrix Tests
    
    func testFloat4x4InitWithOrthographic() {
        let rect = CGRect(x: -10, y: 10, width: 20, height: 20)
        let near: Float = 0.1
        let far: Float = 100
        
        let matrix = float4x4(orthographic: rect, near: near, far: far)
        
        XCTAssertNotEqual(matrix, float4x4.identity)
        
        XCTAssertNotEqual(matrix.columns.0.x, 0)
        XCTAssertNotEqual(matrix.columns.1.y, 0)
        XCTAssertNotEqual(matrix.columns.2.z, 0)
        
        XCTAssertEqual(matrix.columns.3.w, 1, accuracy: 0.001)
    }
    
    func testFloat4x4OrthographicWithDifferentSizes() {
        let near: Float = 0.1
        let far: Float = 100
        
        let smallRect = CGRect(x: -5, y: 5, width: 10, height: 10)
        let largeRect = CGRect(x: -20, y: 20, width: 40, height: 40)
        
        let smallMatrix = float4x4(orthographic: smallRect, near: near, far: far)
        let largeMatrix = float4x4(orthographic: largeRect, near: near, far: far)
        
        XCTAssertNotEqual(smallMatrix, largeMatrix)
        
        XCTAssertNotEqual(smallMatrix.columns.0.x, largeMatrix.columns.0.x)
        XCTAssertNotEqual(smallMatrix.columns.1.y, largeMatrix.columns.1.y)
    }
    
    func testFloat4x4OrthographicScaleCalculation() {
        let rect = CGRect(x: 0, y: 10, width: 100, height: 10)
        let near: Float = 0.1
        let far: Float = 100
        
        let matrix = float4x4(orthographic: rect, near: near, far: far)
        
        let left = Float(rect.origin.x)
        let right = Float(rect.origin.x + rect.width)
        let top = Float(rect.origin.y)
        let bottom = Float(rect.origin.y - rect.height)
        
        let expectedXScale = 2 / (right - left)
        XCTAssertEqual(matrix.columns.0.x, expectedXScale, accuracy: 0.001)
        
        let expectedYScale = 2 / (top - bottom)
        XCTAssertEqual(matrix.columns.1.y, expectedYScale, accuracy: 0.001)
        
        let expectedZScale = 1 / (far - near)
        XCTAssertEqual(matrix.columns.2.z, expectedZScale, accuracy: 0.001)
    }
    
}
