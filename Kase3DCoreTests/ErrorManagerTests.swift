//
//  ErrorManagerTests.swift
//  Kase3DCoreTests
//
//  Created by Anda Levente on 2026. 03. 01..
//

import XCTest

final class ErrorManagerTests: XCTestCase {
    private var errorManager: DummyErrorManager!
    
    override func setUpWithError() throws {
        errorManager = DummyErrorManager()
    }
    
    override func tearDownWithError() throws {
        errorManager = nil
    }
    
    func testErrorPresentationAndDismissal() throws {
        let error = TestError.network
        XCTAssertTrue(errorManager.presentedErrors.isEmpty)
        XCTAssertTrue(errorManager.dismissedErrors.isEmpty)
        errorManager.present(error: error)
        XCTAssertEqual(errorManager.presentedErrors.count, 1)
        XCTAssertEqual(errorManager.presentedErrors.first as? TestError, .network)
        XCTAssertTrue(errorManager.dismissedErrors.isEmpty)
        errorManager.dismiss(error: error)
        XCTAssertEqual(errorManager.dismissedErrors.count, 1)
        XCTAssertEqual(errorManager.dismissedErrors.first as? TestError, .network)
    }
    
    func testErrorMapping() throws {
        let networkMapped = errorManager.map(error: .network)
        XCTAssertEqual(networkMapped.title, "Network Error")
        XCTAssertTrue(networkMapped.canRetry)
        let decodingMapped = errorManager.map(error: .decoding)
        XCTAssertEqual(decodingMapped.title, "Data Error")
        XCTAssertFalse(decodingMapped.canRetry)
        let unknownMapped = errorManager.map(error: .unknown)
        XCTAssertEqual(unknownMapped.title, "Unknown Error")
        XCTAssertFalse(unknownMapped.canRetry)
        XCTAssertEqual(errorManager.lastMappedError, unknownMapped)
    }
    
    func testRetryMechanism() throws {
        var retryExecuted = false
        errorManager.retry(on: .network) {
            retryExecuted = true
        }
        XCTAssertTrue(retryExecuted)
        XCTAssertEqual(errorManager.retryInvocationCount, 1)
        retryExecuted = false
        errorManager.retry(on: .decoding) {
            retryExecuted = true
        }
        XCTAssertFalse(retryExecuted)
        XCTAssertEqual(errorManager.retryInvocationCount, 1, "Retry count should not increase for non-retryable errors")
    }
    
    // MARK: - Test Helpers
    private enum TestError: Error, Equatable {
        case network
        case decoding
        case unknown
    }
    
    private struct MappedError: Equatable {
        let title: String
        let message: String
        let canRetry: Bool
    }
    
    private final class DummyErrorManager {
        private(set) var presentedErrors: [Error] = []
        private(set) var dismissedErrors: [Error] = []
        private(set) var lastMappedError: MappedError?
        private(set) var retryInvocationCount: Int = 0
        
        func present(error: Error) {
            presentedErrors.append(error)
        }
        
        func dismiss(error: Error) {
            dismissedErrors.append(error)
        }
        
        func map(error: TestError) -> MappedError {
            let mapped: MappedError
            switch error {
            case .network:
                mapped = MappedError(title: "Network Error",
                                     message: "Please check your connection and try again.",
                                     canRetry: true)
            case .decoding:
                mapped = MappedError(title: "Data Error",
                                     message: "Received invalid data from server.",
                                     canRetry: false)
            case .unknown:
                mapped = MappedError(title: "Unknown Error",
                                     message: "Something went wrong.",
                                     canRetry: false)
            }
            lastMappedError = mapped
            return mapped
        }
        
        func retry(on error: TestError, handler: () -> Void) {
            let mapped = map(error: error)
            guard mapped.canRetry else { return }
            retryInvocationCount += 1
            handler()
        }
        
    }
    
}
