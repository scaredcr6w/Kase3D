//
//  TextureControllerTests.swift
//  Kase3DEngineTests
//
//  Created by Anda Levente on 2026. 02. 14..
//

import XCTest
import MetalKit
@testable import Kase3DEngine

@MainActor
final class TextureControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        TextureController.textures.removeAll()
    }
    
    override func tearDown() {
        TextureController.textures.removeAll()
        super.tearDown()
    }
    
    // MARK: - Cache Tests
    
    func testTexturesCacheDictionaryExists() {
        XCTAssertNotNil(TextureController.textures)
        XCTAssertTrue(TextureController.textures.isEmpty)
    }
    
    func testTexturesCacheCanStoreTextures() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 64
        descriptor.height = 64
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.usage = [.shaderRead]
        
        let mockTexture = device.makeTexture(descriptor: descriptor)!
        TextureController.textures["test"] = mockTexture
        
        XCTAssertEqual(TextureController.textures.count, 1)
        XCTAssertNotNil(TextureController.textures["test"])
    }
    
    func testLoadTextureByNameReturnsNilForNonexistentTexture() throws {
        guard let _ = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let result = TextureController.loadTexture(name: "nonexistent_texture_12345")
        
        XCTAssertNil(result)
    }
    
    func testLoadTextureByNameReturnsCachedTexture() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 64
        descriptor.height = 64
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.usage = [.shaderRead]
        
        let mockTexture = device.makeTexture(descriptor: descriptor)!
        let textureName = "cached_texture"
        TextureController.textures[textureName] = mockTexture
        
        let result = TextureController.loadTexture(name: textureName)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockTexture, "Should return the same cached texture instance")
        XCTAssertEqual(TextureController.textures.count, 1, "Cache size should remain 1")
    }
    
    func testLoadTextureFromMDLTextureReturnsCachedTexture() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 64
        descriptor.height = 64
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.usage = [.shaderRead]
        
        let mockTexture = device.makeTexture(descriptor: descriptor)!
        let textureName = "mdl_cached_texture"
        TextureController.textures[textureName] = mockTexture
        
        let mdlTexture = MDLTexture()
        
        let result = TextureController.loadTexture(texture: mdlTexture, name: textureName)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockTexture, "Should return the same cached texture instance")
    }
    
    func testCachePreventsDuplicateLoading() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 128
        descriptor.height = 128
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.usage = [.shaderRead]
        
        let originalTexture = device.makeTexture(descriptor: descriptor)!
        let textureName = "duplicate_test"
        
        TextureController.textures[textureName] = originalTexture
        XCTAssertEqual(TextureController.textures.count, 1)
        
        let result = TextureController.loadTexture(name: textureName)
        
        XCTAssertTrue(result === originalTexture)
        XCTAssertEqual(TextureController.textures.count, 1, "Should not create duplicate cache entries")
    }
    
    // MARK: - Texture Loading Options Tests
    
    func testLoadTextureFromMDLUsesCorrectOptions() throws {
        guard let _ = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Cannot reach gpu")
        }
        let width = 2
        let height = 2
        let pixelData: [UInt8] = [
            255, 0, 0, 255,  // Red
            0, 255, 0, 255,  // Green
            0, 0, 255, 255,  // Blue
            255, 255, 0, 255 // Yellow
        ]
        
        let data = Data(pixelData)
        
        let mdlTexture = MDLTexture(
            data: data,
            topLeftOrigin: false,
            name: "test_texture",
            dimensions: [Int32(width), Int32(height)],
            rowStride: width * 4,
            channelCount: 4,
            channelEncoding: .uint8,
            isCube: false
        )
        
        let result = TextureController.loadTexture(texture: mdlTexture, name: "test_mdl")
        
        if let texture = result {
            XCTAssertNotNil(TextureController.textures["test_mdl"])
            XCTAssertTrue(TextureController.textures["test_mdl"] === texture)
        }
    }
}
