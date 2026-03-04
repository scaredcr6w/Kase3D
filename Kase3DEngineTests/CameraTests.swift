//
//  CameraTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 01. 28..
//

import XCTest
@testable import Kase3DEngine

final class ArcballCameraTests: XCTestCase {
    
    var camera: ArcballCamera!
    
    override func setUp() {
        super.setUp()
        camera = ArcballCamera(distance: 5.0, target: .zero)
        camera.update(size: CGSize(width: 800, height: 600))
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertEqual(camera.distance, 5.0)
        XCTAssertEqual(camera.target, float3.zero)
        XCTAssertEqual(camera.orientation.real, 1.0, accuracy: 0.001)
        XCTAssertEqual(camera.orientation.imag, float3.zero)
    }
    
    func testInitialPosition() {
        let expectedPosition = float3(0, 0, 5.0)
        XCTAssertEqual(camera.position.x, expectedPosition.x, accuracy: 0.001)
        XCTAssertEqual(camera.position.y, expectedPosition.y, accuracy: 0.001)
        XCTAssertEqual(camera.position.z, expectedPosition.z, accuracy: 0.001)
    }
    
    func testAspectRatioUpdate() {
        camera.update(size: CGSize(width: 1920, height: 1080))
        XCTAssertEqual(camera.aspect, 1920.0 / 1080.0, accuracy: 0.001)
    }
    
    // MARK: - Drag/Rotation Tests
    
    func testHorizontalDrag() {
        let initialOrientation = camera.orientation
        camera.drag(float2(10.0, 0.0))
        
        XCTAssertNotEqual(camera.orientation.real, initialOrientation.real)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.001)
    }
    
    func testVerticalDrag() {
        let initialOrientation = camera.orientation
        camera.drag(float2(0.0, 10.0))
        
        XCTAssertNotEqual(camera.orientation.real, initialOrientation.real)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.001)
    }
    
    func testPitchClamping() {
        for _ in 0..<100 {
            camera.drag(float2(0.0, 1.0))
        }
        
        let forward = camera.orientation.act(float3(0, 0, -1))
        let pitch = asin(max(-1.0, min(1.0, forward.y)))
        
        XCTAssertLessThan(pitch, .pi / 2)
        XCTAssertGreaterThan(pitch, -.pi / 2)
    }
    
    func testPitchClampingNegative() {
        for _ in 0..<100 {
            camera.drag(float2(0.0, -1.0))
        }
        
        let forward = camera.orientation.act(float3(0, 0, -1))
        let pitch = asin(max(-1.0, min(1.0, forward.y)))
        
        XCTAssertLessThan(pitch, .pi / 2)
        XCTAssertGreaterThan(pitch, -.pi / 2)
    }
    
    func testYawDoesNotAffectUpVector() {
        camera.drag(float2(50.0, 0.0))
        
        let up = camera.orientation.act(float3(0, 1, 0))
        
        XCTAssertGreaterThan(up.y, 0.9)
    }
    
    func testOrientationNormalization() {
        for _ in 0..<10 {
            camera.drag(float2(5.0, 3.0))
        }
        
        let magnitude = sqrt(
            camera.orientation.real * camera.orientation.real +
            dot(camera.orientation.imag, camera.orientation.imag)
        )
        XCTAssertEqual(magnitude, 1.0, accuracy: 0.001)
    }
    
    // MARK: - Zoom Tests
    
    func testZoomIn() {
        let initialDistance = camera.distance
        camera.zoom(1.0)
        
        XCTAssertLessThan(camera.distance, initialDistance)
    }
    
    func testZoomOut() {
        let initialDistance = camera.distance
        camera.zoom(-1.0)
        
        XCTAssertGreaterThan(camera.distance, initialDistance)
    }
    
    func testZoomMinimumClamp() {
        camera.zoom(1000.0)
        
        XCTAssertGreaterThanOrEqual(camera.distance, 0.1)
    }
    
    func testZoomDoesNotAffectOrientation() {
        let initialOrientation = camera.orientation
        camera.zoom(2.0)
        
        XCTAssertEqual(camera.orientation.real, initialOrientation.real, accuracy: 0.001)
        XCTAssertEqual(camera.orientation.imag, initialOrientation.imag)
    }
    
    // MARK: - Pan Tests
    
    func testPanHorizontal() {
        let initialTarget = camera.target
        camera.pan(float2(10.0, 0.0))
        
        XCTAssertNotEqual(camera.target, initialTarget)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.001)
    }
    
    func testPanVertical() {
        let initialTarget = camera.target
        camera.pan(float2(0.0, 10.0))
        
        XCTAssertNotEqual(camera.target, initialTarget)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.001)
    }
    
    func testPanDoesNotAffectOrientation() {
        let initialOrientation = camera.orientation
        camera.pan(float2(5.0, 5.0))
        
        XCTAssertEqual(camera.orientation.real, initialOrientation.real, accuracy: 0.001)
        XCTAssertEqual(camera.orientation.imag, initialOrientation.imag)
    }
    
    func testPanFromTopDown() {
        for _ in 0..<50 {
            camera.drag(float2(0.0, 1.0))
        }
        
        let initialTargetY = camera.target.y
        camera.pan(float2(0.0, 10.0))
        
        XCTAssertNotEqual(camera.target.y, initialTargetY)
    }
    
    func testPanFromHorizontal() {
        let initialTarget = camera.target
        camera.pan(float2(0.0, 10.0))
        
        XCTAssertNotEqual(camera.target, initialTarget, "Target should move when panning")
    }


    
    // MARK: - View Matrix Tests
    
    func testViewMatrixIsInvertible() {
        let viewMatrix = camera.viewMatrix
        let determinant = viewMatrix.determinant
        
        XCTAssertNotEqual(determinant, 0.0)
    }
    
    func testViewMatrixStructure() {
        let viewMatrix = camera.viewMatrix
        
        let determinant = viewMatrix.determinant
        XCTAssertNotEqual(determinant, 0.0, "View matrix should be invertible")
        
        let initialViewMatrix = camera.viewMatrix
        camera.drag(float2(10.0, 5.0))
        let newViewMatrix = camera.viewMatrix
        
        XCTAssertNotEqual(
            initialViewMatrix,
            newViewMatrix,
            "View matrix should change when camera rotates"
        )
    }

    
    func testViewMatrixAfterRotation() {
        camera.drag(float2(10.0, 5.0))
        
        let viewMatrix = camera.viewMatrix
        let determinant = viewMatrix.determinant
        
        XCTAssertNotEqual(determinant, 0.0)
    }
    
    // MARK: - Projection Matrix Tests
    
    func testProjectionMatrixGeneration() {
        let projMatrix = camera.projectionMatrix
        
        XCTAssertNotEqual(projMatrix, float4x4(diagonal: float4(1, 1, 1, 1)))
    }
    
    func testProjectionMatrixAspectRatio() {
        camera.update(size: CGSize(width: 1600, height: 800))
        let projMatrix = camera.projectionMatrix
        
        XCTAssertNotEqual(projMatrix[0][0], projMatrix[1][1])
    }
    
    // MARK: - Integration Tests
    
    func testCombinedOperations() {
        camera.drag(float2(10.0, 5.0))
        camera.zoom(1.0)
        camera.pan(float2(2.0, 3.0))
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertGreaterThan(distanceToTarget, 0.0)
        
        let magnitude = sqrt(
            camera.orientation.real * camera.orientation.real +
            dot(camera.orientation.imag, camera.orientation.imag)
        )
        XCTAssertEqual(magnitude, 1.0, accuracy: 0.001)
    }
    
    func testOrbitAroundTarget() {
        let target = float3(1, 2, 3)
        camera.target = target
        
        for _ in 0..<36 {
            camera.drag(float2(1.0, 0.0))
        }
        
        XCTAssertEqual(camera.target, target)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.01)
    }
    
    func testNoDragWithZeroInput() {
        let initialOrientation = camera.orientation
        camera.drag(float2.zero)
        
        XCTAssertEqual(camera.orientation.real, initialOrientation.real, accuracy: 0.001)
        XCTAssertEqual(camera.orientation.imag, initialOrientation.imag)
    }
    
    func testNoPanWithZeroInput() {
        let initialTarget = camera.target
        camera.pan(float2.zero)
        
        XCTAssertEqual(camera.target, initialTarget)
    }
    
    func testNoZoomWithZeroInput() {
        let initialDistance = camera.distance
        camera.zoom(0.0)
        
        XCTAssertEqual(camera.distance, initialDistance)
    }
    
    // MARK: - Edge Cases
    
    func testVerySmallDistance() {
        camera.distance = 0.1
        
        let position = camera.position
        let distanceToTarget = length(position - camera.target)
        
        XCTAssertEqual(distanceToTarget, 0.1, accuracy: 0.001)
    }
    
    func testVeryLargeDistance() {
        camera.distance = 1000.0
        
        let position = camera.position
        let distanceToTarget = length(position - camera.target)
        
        XCTAssertEqual(distanceToTarget, 1000.0, accuracy: 0.01)
    }
    
    func testNonZeroTarget() {
        camera.target = float3(10, 20, 30)
        
        let distanceToTarget = length(camera.position - camera.target)
        XCTAssertEqual(distanceToTarget, 5.0, accuracy: 0.001)
    }
}

// MARK: - Helper Extensions

extension float4x4 {
    var determinant: Float {
        let a = self[0][0], b = self[0][1], c = self[0][2], d = self[0][3]
        let e = self[1][0], f = self[1][1], g = self[1][2], h = self[1][3]
        let i = self[2][0], j = self[2][1], k = self[2][2], l = self[2][3]
        let m = self[3][0], n = self[3][1], o = self[3][2], p = self[3][3]
        
        return a * (f * (k * p - l * o) - g * (j * p - l * n) + h * (j * o - k * n)) -
               b * (e * (k * p - l * o) - g * (i * p - l * m) + h * (i * o - k * m)) +
               c * (e * (j * p - l * n) - f * (i * p - l * m) + h * (i * n - j * m)) -
               d * (e * (j * o - k * n) - f * (i * o - k * m) + g * (i * n - j * m))
    }
}
