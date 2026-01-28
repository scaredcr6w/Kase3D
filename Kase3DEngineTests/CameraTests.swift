//
//  CameraTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 01. 28..
//

import XCTest
@testable import Kase3DEngine

final class CameraTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testArcballCameraDefaultInitialization() {
        let camera = ArcballCamera()
        
        XCTAssertEqual(camera.aspect, 1.0)
        XCTAssertEqual(camera.fov, Float(70).toRadians)
        XCTAssertEqual(camera.near, 0.1)
        XCTAssertEqual(camera.far, 100)
        XCTAssertEqual(camera.minDistance, 0)
        XCTAssertEqual(camera.maxDistance, 20)
        XCTAssertEqual(camera.target, float3(0, 0, 0))
        XCTAssertEqual(camera.distance, 2.5)
        XCTAssertEqual(camera.position, float3(0, 0, 0))
        XCTAssertEqual(camera.rotation, float3(0, 0, 0))
    }
    
    // MARK: - Projection Matrix Tests
    
    func testProjectionMatrixWithDefaultValues() {
        let camera = ArcballCamera()
        
        let projectionMatrix = camera.projectionMatrix
        
        XCTAssertNotEqual(projectionMatrix, float4x4.identity)
        XCTAssertNotEqual(projectionMatrix.columns.0.x, 0)
        XCTAssertNotEqual(projectionMatrix.columns.1.y, 0)
    }
    
    func testProjectionMatrixChangesWithAspect() {
        var camera = ArcballCamera()
        camera.aspect = 1.0
        let matrix1 = camera.projectionMatrix
        
        camera.aspect = 16.0 / 9.0
        let matrix2 = camera.projectionMatrix
        
        XCTAssertNotEqual(matrix1.columns.0.x, matrix2.columns.0.x)
    }
    
    func testProjectionMatrixChangesWithFOV() {
        var camera = ArcballCamera()
        camera.fov = Float(45).toRadians
        let matrix1 = camera.projectionMatrix
        
        camera.fov = Float(90).toRadians
        let matrix2 = camera.projectionMatrix
        
        XCTAssertNotEqual(matrix1.columns.1.y, matrix2.columns.1.y)
    }
    
    // MARK: - View Matrix Tests
    
    func testViewMatrixAtOrigin() {
        var camera = ArcballCamera()
        camera.target = float3(0, 0, 0)
        camera.position = float3(0, 0, 2.5)
        camera.rotation = float3(0, 0, 0)
        
        let viewMatrix = camera.viewMatrix
        
        XCTAssertNotEqual(viewMatrix, float4x4.identity)
    }
    
    func testViewMatrixWhenTargetEqualsPosition() {
        var camera = ArcballCamera()
        camera.target = float3(1, 2, 3)
        camera.position = float3(1, 2, 3)
        camera.rotation = float3(0, 0, 0)
        
        let viewMatrix = camera.viewMatrix
        
        XCTAssertNotEqual(viewMatrix, float4x4.identity)
    }
    
    func testViewMatrixChangesWithRotation() {
        var camera = ArcballCamera()
        camera.target = float3(0, 0, 0)
        camera.position = float3(0, 0, 0)
        camera.rotation = float3(0, 0, 0)
        let matrix1 = camera.viewMatrix
        
        camera.rotation = float3(0.5, 0, 0)
        let matrix2 = camera.viewMatrix
        
        XCTAssertNotEqual(matrix1, matrix2)
    }
    
    // MARK: - Update Size Tests
    
    func testUpdateSizeCalculatesCorrectAspectRatio() {
        var camera = ArcballCamera()
        
        let size = CGSize(width: 1920, height: 1080)
        camera.update(size: size)
        
        let expectedAspect = Float(1920.0 / 1080.0)
        XCTAssertEqual(camera.aspect, expectedAspect, accuracy: 0.001)
    }
    
    func testUpdateSizeWithSquareResolution() {
        var camera = ArcballCamera()
        
        let size = CGSize(width: 800, height: 800)
        camera.update(size: size)
        
        XCTAssertEqual(camera.aspect, 1.0, accuracy: 0.001)
    }
    
    func testUpdateSizeWithPortraitResolution() {
        var camera = ArcballCamera()
        
        let size = CGSize(width: 1080, height: 1920)
        camera.update(size: size)
        
        let expectedAspect = Float(1080.0 / 1920.0)
        XCTAssertEqual(camera.aspect, expectedAspect, accuracy: 0.001)
    }
    
    // MARK: - Distance and Position Tests
    
    func testInitialPositionCalculation() {
        var camera = ArcballCamera()
        camera.distance = 5.0
        camera.target = float3(0, 0, 0)
        camera.rotation = float3(0, 0, 0)
        
        let expectedPosition = float3(0, 0, -5.0)
        
        let rotateMatrix = float4x4(rotationYXZ: [-camera.rotation.x, camera.rotation.y, 0])
        let distanceVector = float4(0, 0, -camera.distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        let calculatedPosition = camera.target + rotatedVector.xyz
        
        XCTAssertEqual(calculatedPosition.x, expectedPosition.x, accuracy: 0.001)
        XCTAssertEqual(calculatedPosition.y, expectedPosition.y, accuracy: 0.001)
        XCTAssertEqual(calculatedPosition.z, expectedPosition.z, accuracy: 0.001)
    }
    
    func testPositionCalculationWithRotation() {
        var camera = ArcballCamera()
        camera.distance = 5.0
        camera.target = float3(0, 0, 0)
        camera.rotation = float3(-Float.pi / 4, 0, 0)
        
        let rotateMatrix = float4x4(rotationYXZ: [-camera.rotation.x, camera.rotation.y, 0])
        let distanceVector = float4(0, 0, -camera.distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        let calculatedPosition = camera.target + rotatedVector.xyz
        
        XCTAssertGreaterThan(calculatedPosition.y, 0)
    }
    
    // MARK: - Transformable Protocol Tests
    
    func testTransformableProtocolPosition() {
        var camera = ArcballCamera()
        
        camera.position = float3(1, 2, 3)
        
        XCTAssertEqual(camera.position, float3(1, 2, 3))
        XCTAssertEqual(camera.transform.position, float3(1, 2, 3))
    }
    
    func testTransformableProtocolRotation() {
        var camera = ArcballCamera()
        
        camera.rotation = float3(0.5, 1.0, 0.2)
        
        XCTAssertEqual(camera.rotation, float3(0.5, 1.0, 0.2))
        XCTAssertEqual(camera.transform.rotation, float3(0.5, 1.0, 0.2))
    }
    
    func testTransformableProtocolScale() {
        var camera = ArcballCamera()
        
        camera.scale = 2.0
        
        XCTAssertEqual(camera.scale, 2.0)
        XCTAssertEqual(camera.transform.scale, 2.0)
    }
    
    // MARK: - Edge Cases
    
    func testExtremelyNarrowFOV() {
        var camera = ArcballCamera()
        camera.fov = Float(1).toRadians
        
        let projectionMatrix = camera.projectionMatrix
        
        XCTAssertNotEqual(projectionMatrix, float4x4.identity)
    }
    
    func testExtremelyWideFOV() {
        var camera = ArcballCamera()
        camera.fov = Float(179).toRadians
        
        let projectionMatrix = camera.projectionMatrix
        
        XCTAssertNotEqual(projectionMatrix, float4x4.identity)
    }
    
    func testZeroDistance() {
        var camera = ArcballCamera()
        camera.distance = 0
        camera.target = float3(0, 0, 0)
        
        let rotateMatrix = float4x4(rotationYXZ: [-camera.rotation.x, camera.rotation.y, 0])
        let distanceVector = float4(0, 0, -camera.distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        let calculatedPosition = camera.target + rotatedVector.xyz
        
        XCTAssertEqual(calculatedPosition, camera.target)
    }
    
    func testNegativeTargetCoordinates() {
        var camera = ArcballCamera()
        camera.target = float3(-5, -10, -15)
        camera.distance = 3.0
        camera.rotation = float3(0, 0, 0)
        
        let rotateMatrix = float4x4(rotationYXZ: [-camera.rotation.x, camera.rotation.y, 0])
        let distanceVector = float4(0, 0, -camera.distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        let calculatedPosition = camera.target + rotatedVector.xyz
        
        // Camera should orbit around negative target
        XCTAssertLessThan(calculatedPosition.z, camera.target.z)
    }
    
    // MARK: - Matrix Properties Tests
    
    func testViewProjectionMatrixCombination() {
        var camera = ArcballCamera()
        camera.aspect = 16.0 / 9.0
        camera.position = float3(0, 2, 5)
        camera.target = float3(0, 0, 0)
        
        let viewMatrix = camera.viewMatrix
        let projectionMatrix = camera.projectionMatrix
        let viewProjection = projectionMatrix * viewMatrix
        
        XCTAssertNotEqual(viewProjection, viewMatrix)
        XCTAssertNotEqual(viewProjection, projectionMatrix)
    }
    
}
