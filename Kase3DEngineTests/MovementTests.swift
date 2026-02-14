//
//  MovementTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 02. 14..
//

import XCTest
import GameController
@testable import Kase3DEngine

final class MovementTests: XCTestCase {
    struct MockMovableObject: Transformable, Movement {
        var transform: Transform = .init()
    }
    
    override func setUp() {
        super.setUp()
        InputController.shared.keysPressed.removeAll()
    }
    
    override func tearDown() {
        InputController.shared.keysPressed.removeAll()
        super.tearDown()
    }
    
    // MARK: - Settings Tests
    
    func testSettingsRotationSpeed() {
        XCTAssertEqual(Settings.rotationSpeed, 2.0)
    }
    
    func testSettingsTranslationSpeed() {
        XCTAssertEqual(Settings.translationSpeed, 3.0)
    }
    
    func testSettingsMouseScrollSensitivity() {
        XCTAssertEqual(Settings.mouseScrollSensitivity, 0.1)
    }
    
    func testSettingsMousePanSensitivity() {
        XCTAssertEqual(Settings.mousePanSensitivity, 0.008)
    }
    
    func testSettingsTouchZoomSensitivity() {
        XCTAssertEqual(Settings.touchZoomSensitivity, 10)
    }
    
    // MARK: - Forward Vector Tests
    
    func testForwardVectorAtZeroRotation() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        let forward = mock.forwardVector
        
        XCTAssertEqual(forward.x, 0, accuracy: 0.001)
        XCTAssertEqual(forward.y, 0, accuracy: 0.001)
        XCTAssertEqual(forward.z, 1, accuracy: 0.001)
    }
    
    func testForwardVectorAt90DegreesYRotation() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, Float.pi / 2, 0)
        
        let forward = mock.forwardVector
        
        XCTAssertEqual(forward.x, 1, accuracy: 0.001)
        XCTAssertEqual(forward.y, 0, accuracy: 0.001)
        XCTAssertEqual(forward.z, 0, accuracy: 0.001)
    }
    
    func testForwardVectorAt180DegreesYRotation() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, Float.pi, 0)
        
        let forward = mock.forwardVector
        
        XCTAssertEqual(forward.x, 0, accuracy: 0.001)
        XCTAssertEqual(forward.y, 0, accuracy: 0.001)
        XCTAssertEqual(forward.z, -1, accuracy: 0.001)
    }
    
    func testForwardVectorIsNormalized() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0.5, 0)
        
        let forward = mock.forwardVector
        let length = sqrt(forward.x * forward.x + forward.y * forward.y + forward.z * forward.z)
        
        XCTAssertEqual(length, 1, accuracy: 0.001)
    }
    
    func testForwardVectorYComponentIsAlwaysZero() {
        var mock = MockMovableObject()
        
        for angle in stride(from: 0.0, through: Float.pi * 2, by: Float.pi / 4) {
            mock.rotation = float3(0, angle, 0)
            let forward = mock.forwardVector
            XCTAssertEqual(forward.y, 0, accuracy: 0.001)
        }
    }
    
    // MARK: - Right Vector Tests
    
    func testRightVectorAtZeroRotation() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        let right = mock.rightVector
        let forward = mock.forwardVector
        
        XCTAssertEqual(right.x, forward.z, accuracy: 0.001)
        XCTAssertEqual(right.y, forward.y, accuracy: 0.001)
        XCTAssertEqual(right.z, -forward.x, accuracy: 0.001)
    }
    
    func testRightVectorIsPerpendicular() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0.5, 0)
        
        let forward = mock.forwardVector
        let right = mock.rightVector
        
        let dotProduct = forward.x * right.x + forward.y * right.y + forward.z * right.z
        XCTAssertEqual(dotProduct, 0, accuracy: 0.001)
    }
    
    func testRightVectorCalculation() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, Float.pi / 4, 0)
        
        let forward = mock.forwardVector
        let right = mock.rightVector
        
        XCTAssertEqual(right.x, forward.z, accuracy: 0.001)
        XCTAssertEqual(right.y, forward.y, accuracy: 0.001)
        XCTAssertEqual(right.z, -forward.x, accuracy: 0.001)
    }
    
    // MARK: - UpdateInput Tests (No Input)
    
    func testUpdateInputWithNoKeysPressed() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        XCTAssertEqual(result.position, float3(0, 0, 0))
        XCTAssertEqual(result.rotation, float3(0, 0, 0))
    }
    
    // MARK: - UpdateInput Tests (Rotation)
    
    func testUpdateInputWithLeftArrowRotatesLeft() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.leftArrow)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedRotation = deltaTime * Settings.rotationSpeed
        XCTAssertEqual(result.rotation.y, -expectedRotation, accuracy: 0.001)
    }
    
    func testUpdateInputWithRightArrowRotatesRight() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.rightArrow)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedRotation = deltaTime * Settings.rotationSpeed
        XCTAssertEqual(result.rotation.y, expectedRotation, accuracy: 0.001)
    }
    
    // MARK: - UpdateInput Tests (Translation)
    
    func testUpdateInputWithWKeyMovesForward() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyW)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedDistance = deltaTime * Settings.translationSpeed
        
        XCTAssertEqual(result.position.x, 0, accuracy: 0.001)
        XCTAssertEqual(result.position.z, expectedDistance, accuracy: 0.001)
    }
    
    func testUpdateInputWithSKeyMovesBackward() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyS)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedDistance = deltaTime * Settings.translationSpeed
        
        XCTAssertEqual(result.position.x, 0, accuracy: 0.001)
        XCTAssertEqual(result.position.z, -expectedDistance, accuracy: 0.001)
    }
    
    func testUpdateInputWithAKeyMovesLeft() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyA)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedDistance = deltaTime * Settings.translationSpeed
        
        XCTAssertEqual(result.position.x, -expectedDistance, accuracy: 0.001)
        XCTAssertEqual(result.position.z, 0, accuracy: 0.001)
    }
    
    func testUpdateInputWithDKeyMovesRight() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyD)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        let expectedDistance = deltaTime * Settings.translationSpeed
        
        XCTAssertEqual(result.position.x, expectedDistance, accuracy: 0.001)
        XCTAssertEqual(result.position.z, 0, accuracy: 0.001)
    }
    
    // MARK: - UpdateInput Tests (Combined Movement)
    
    func testUpdateInputWithDiagonalMovement() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyW)
        InputController.shared.keysPressed.insert(.keyD)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        XCTAssertGreaterThan(result.position.x, 0)
        XCTAssertGreaterThan(result.position.z, 0)
        
        let distance = sqrt(result.position.x * result.position.x + result.position.z * result.position.z)
        XCTAssertEqual(distance, deltaTime * Settings.translationSpeed, accuracy: 0.001)
    }
    
    func testUpdateInputNormalizesDirection() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyW)
        InputController.shared.keysPressed.insert(.keyS)
        InputController.shared.keysPressed.insert(.keyA)
        InputController.shared.keysPressed.insert(.keyD)
        let deltaTime: Float = 0.1
        let result = mock.updateInput(deltaTime: deltaTime)
        
        XCTAssertEqual(result.position, float3(0, 0, 0))
    }
    
    func testUpdateInputScalesWithDeltaTime() {
        var mock = MockMovableObject()
        mock.rotation = float3(0, 0, 0)
        
        InputController.shared.keysPressed.insert(.keyW)
        
        let deltaTime1: Float = 0.1
        let result1 = mock.updateInput(deltaTime: deltaTime1)
        
        InputController.shared.keysPressed.removeAll()
        InputController.shared.keysPressed.insert(.keyW)
        
        let deltaTime2: Float = 0.2
        let result2 = mock.updateInput(deltaTime: deltaTime2)
        
        XCTAssertEqual(result2.position.z / result1.position.z, deltaTime2 / deltaTime1, accuracy: 0.001)
    }
    
    // MARK: - Movement Protocol Conformance Tests
    
    func testMovementProtocolRequiresTransformable() {
        let mock = MockMovableObject()
        
        XCTAssertNotNil(mock.transform)
        XCTAssertNotNil(mock.position)
        XCTAssertNotNil(mock.rotation)
        XCTAssertNotNil(mock.scale)
        
        XCTAssertNotNil(mock.forwardVector)
        XCTAssertNotNil(mock.rightVector)
    }
    
}
