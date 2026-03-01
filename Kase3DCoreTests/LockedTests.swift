//
//  LockedTests.swift
//  Kase3DCoreTests
//
//  Created by Anda Levente on 2026. 03. 01..
//

import XCTest
@testable import Kase3DCore

final class LockedTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testInitialValue() {
        let locked = Locked(wrappedValue: 42)
        XCTAssertEqual(locked.wrappedValue, 42)
    }
    
    func testSetAndGetValue() {
        let locked = Locked(wrappedValue: 0)
        locked.wrappedValue = 100
        XCTAssertEqual(locked.wrappedValue, 100)
    }
    
    func testMultipleUpdates() {
        let locked = Locked(wrappedValue: 0)
        
        for i in 1...10 {
            locked.wrappedValue = i
            XCTAssertEqual(locked.wrappedValue, i)
        }
    }
    
    // MARK: - Concurrency Tests
    
    func testConcurrentReads() {
        let locked = Locked(wrappedValue: 42)
        let expectation = XCTestExpectation(description: "Concurrent reads complete")
        expectation.expectedFulfillmentCount = 100
        
        for _ in 0..<100 {
            DispatchQueue.global().async {
                let value = locked.wrappedValue
                XCTAssertEqual(value, 42)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testConcurrentWrites() {
        let locked = Locked(wrappedValue: 0)
        let expectation = XCTestExpectation(description: "Concurrent writes complete")
        let iterations = 1000
        expectation.expectedFulfillmentCount = iterations
        
        for i in 0..<iterations {
            DispatchQueue.global().async {
                locked.wrappedValue = i
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        let finalValue = locked.wrappedValue
        XCTAssertTrue((0..<iterations).contains(finalValue))
    }
    
    func testConcurrentIncrement() {
        let locked = Locked(wrappedValue: 0)
        let expectation = XCTestExpectation(description: "Concurrent increments complete")
        let iterations = 1000
        expectation.expectedFulfillmentCount = iterations
        
        for _ in 0..<iterations {
            DispatchQueue.global().async {
                let current = locked.wrappedValue
                locked.wrappedValue = current + 1
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        let finalValue = locked.wrappedValue
        XCTAssertGreaterThan(finalValue, 0)
        XCTAssertLessThanOrEqual(finalValue, iterations)
    }
    
    func testConcurrentReadWrite() {
        let locked = Locked(wrappedValue: 0)
        let expectation = XCTestExpectation(description: "Concurrent read/write complete")
        let iterations = 500
        expectation.expectedFulfillmentCount = iterations * 2
        
        for i in 0..<iterations {
            DispatchQueue.global().async {
                locked.wrappedValue = i
                expectation.fulfill()
            }
        }
        
        for _ in 0..<iterations {
            DispatchQueue.global().async {
                _ = locked.wrappedValue
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        let finalValue = locked.wrappedValue
        XCTAssertTrue((0..<iterations).contains(finalValue))
    }
    
    // MARK: - Sendable Type Tests
    
    func testWithStringType() {
        let locked = Locked(wrappedValue: "initial")
        locked.wrappedValue = "updated"
        XCTAssertEqual(locked.wrappedValue, "updated")
    }
    
    func testWithArrayType() {
        let locked = Locked(wrappedValue: [1, 2, 3])
        locked.wrappedValue.append(4)
        XCTAssertEqual(locked.wrappedValue, [1, 2, 3, 4])
    }
    
    func testWithOptionalType() {
        let locked = Locked<Int?>(wrappedValue: nil)
        XCTAssertNil(locked.wrappedValue)
        
        locked.wrappedValue = 42
        XCTAssertEqual(locked.wrappedValue, 42)
        
        locked.wrappedValue = nil
        XCTAssertNil(locked.wrappedValue)
    }
    
    // MARK: - Stress Tests
    
    func testHighContentionScenario() {
        let locked = Locked(wrappedValue: 0)
        let expectation = XCTestExpectation(description: "High contention complete")
        let threadCount = 50
        let operationsPerThread = 100
        expectation.expectedFulfillmentCount = threadCount * operationsPerThread
        
        for threadId in 0..<threadCount {
            DispatchQueue.global().async {
                for operation in 0..<operationsPerThread {
                    if operation % 2 == 0 {
                        locked.wrappedValue = threadId * operationsPerThread + operation
                    } else {
                        _ = locked.wrappedValue
                    }
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testRapidSequentialAccess() {
        let locked = Locked(wrappedValue: 0)
        
        for i in 0..<10000 {
            locked.wrappedValue = i
            let value = locked.wrappedValue
            XCTAssertEqual(value, i)
        }
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceOfWrites() {
        let locked = Locked(wrappedValue: 0)
        
        measure {
            for i in 0..<1000 {
                locked.wrappedValue = i
            }
        }
    }
    
    func testPerformanceOfReads() {
        let locked = Locked(wrappedValue: 42)
        
        measure {
            for _ in 0..<1000 {
                _ = locked.wrappedValue
            }
        }
    }
    
    func testPerformanceOfConcurrentAccess() {
        let locked = Locked(wrappedValue: 0)
        
        measure {
            let expectation = XCTestExpectation(description: "Concurrent access")
            expectation.expectedFulfillmentCount = 100
            
            for i in 0..<100 {
                DispatchQueue.global().async {
                    locked.wrappedValue = i
                    _ = locked.wrappedValue
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
}
