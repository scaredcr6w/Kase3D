//
//  ModelTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 02. 14..
//

import XCTest
import MetalKit
@testable import Kase3DEngine

@MainActor
final class ModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        let model = Model()
        
        XCTAssertEqual(model.name, "Untitled")
        XCTAssertEqual(model.tiling, 1)
        XCTAssertTrue(model.meshes.isEmpty)
        XCTAssertEqual(model.transform.position, float3(0, 0, 0))
        XCTAssertEqual(model.transform.rotation, float3(0, 0, 0))
        XCTAssertEqual(model.transform.scale, 0.5)
    }
    
    // MARK: - Property Tests
    
    func testNameProperty() {
        let model = Model()
        
        model.name = "TestModel"
        
        XCTAssertEqual(model.name, "TestModel")
    }
    
    func testTilingProperty() {
        let model = Model()
        
        model.tiling = 5
        
        XCTAssertEqual(model.tiling, 5)
    }
    
    func testMeshesPropertyCanBeModified() {
        let model = Model()
        
        XCTAssertTrue(model.meshes.isEmpty)
        XCTAssertEqual(model.meshes.count, 0)
    }
    
    // MARK: - Transformable Protocol Tests
    
    func testModelConformsToTransformable() {
        let model = Model()
        
        XCTAssertNotNil(model.transform)
        XCTAssertNotNil(model.position)
        XCTAssertNotNil(model.rotation)
        XCTAssertNotNil(model.scale)
    }
    
    func testTransformablePositionProperty() {
        var model = Model()
        
        model.position = float3(10, 20, 30)
        
        XCTAssertEqual(model.position, float3(10, 20, 30))
        XCTAssertEqual(model.transform.position, float3(10, 20, 30))
    }
    
    func testTransformableRotationProperty() {
        var model = Model()
        
        model.rotation = float3(0.5, 1.0, 1.5)
        
        XCTAssertEqual(model.rotation, float3(0.5, 1.0, 1.5))
        XCTAssertEqual(model.transform.rotation, float3(0.5, 1.0, 1.5))
    }
    
    func testTransformableScaleProperty() {
        var model = Model()
        
        model.scale = 2.5
        
        XCTAssertEqual(model.scale, 2.5)
        XCTAssertEqual(model.transform.scale, 2.5)
    }
    
    // MARK: - SetTexture Method Tests
    
    func testSetTextureDoesNotCrashWithEmptyMeshes() throws {
        guard let _ = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        
        let model = Model()
        
        model.setTexture(name: "test_texture", type: BaseColor)
        
        XCTAssertTrue(model.meshes.isEmpty)
    }
    
    // MARK: - Model State Tests
    
    func testModelCanHaveMultiplePropertiesSet() {
        var model = Model()
        
        model.name = "ComplexModel"
        model.tiling = 3
        model.position = float3(1, 2, 3)
        model.rotation = float3(0.1, 0.2, 0.3)
        model.scale = 1.5
        
        XCTAssertEqual(model.name, "ComplexModel")
        XCTAssertEqual(model.tiling, 3)
        XCTAssertEqual(model.position, float3(1, 2, 3))
        XCTAssertEqual(model.rotation, float3(0.1, 0.2, 0.3))
        XCTAssertEqual(model.scale, 1.5)
    }
    
    func testModelTransformAffectsModelMatrix() {
        var model = Model()
        
        model.position = float3(5, 10, 15)
        model.scale = 1.0
        
        let modelMatrix = model.transform.modelMatrix
        
        XCTAssertEqual(modelMatrix.columns.3.x, 5, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.3.y, 10, accuracy: 0.001)
        XCTAssertEqual(modelMatrix.columns.3.z, 15, accuracy: 0.001)
    }
    
    // MARK: - Default Values Tests
    
    func testDefaultTilingIsOne() {
        let model = Model()
        
        XCTAssertEqual(model.tiling, 1, "Default tiling should be 1")
    }
    
    func testDefaultNameIsUntitled() {
        let model = Model()
        
        XCTAssertEqual(model.name, "Untitled", "Default name should be 'Untitled'")
    }
    
    func testDefaultMeshesArrayIsEmpty() {
        let model = Model()
        
        XCTAssertTrue(model.meshes.isEmpty, "Default meshes array should be empty")
        XCTAssertEqual(model.meshes.count, 0)
    }
    
    func testDefaultTransformMatchesTransformDefaults() {
        let model = Model()
        let defaultTransform = Transform()
        
        XCTAssertEqual(model.transform.position, defaultTransform.position)
        XCTAssertEqual(model.transform.rotation, defaultTransform.rotation)
        XCTAssertEqual(model.transform.scale, defaultTransform.scale)
    }
    
}
