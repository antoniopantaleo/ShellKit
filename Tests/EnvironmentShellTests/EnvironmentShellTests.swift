import XCTest
import ShellKit

final class EnvironmentShellTests: XCTestCase {
    
    func test_run_commandSucceds() async throws {
        // Given
        let sut = EnvironmentShell()
        // When
        let output = try await sut.run("echo", "Hello World")
        // Then
        XCTAssertEqual("Hello World", output)
    }
    
    func test_run_throwsErrorOnInvalidCommand() async {
        // Given
        let sut = EnvironmentShell()
        let expectedErrorString = "env: command_that_does_not_exist: No such file or directory"
        // When
        do {
            let output = try await sut.run("command_that_does_not_exist")
            XCTFail("Expected to fail, got \(output) instead")
        } catch {
            // Then
            XCTAssertEqual(expectedErrorString, (error as NSError).domain)
        }
    }
    
    func test_run_throwsErrorOnNonUtf8Output() async throws {
        // Given
        let sut = EnvironmentShell()
        let expectedError = NSError(
            domain: NSCocoaErrorDomain,
            code: NSFileReadInapplicableStringEncodingError
        )
        let nonUTF8String = try XCTUnwrap(String(data: Data([0x80]), encoding: .ascii))
        // When
        do {
            let output = try await sut.run("echo", "-n", nonUTF8String)
            XCTFail("Expected to fail, got \(output) instead")
        } catch {
            // Then
            XCTAssertEqual(expectedError, error as NSError)
        }
    }
    
    func test_run_isOnBackgroundThread() throws {
        XCTAssertTrue(Thread.isMainThread)
        // Given
        let sut = EnvironmentShell()
        Task {
            // When
            try await sut.run("echo", "Hello World")
            // Then
            XCTAssertFalse(Thread.isMainThread)
        }
    }

    func test_runCommandWithDelay_isCancelledBeforeCompletion() async {
        // Given
        let sut = EnvironmentShell()
        // When
        let task = Task<String, Error> {
            try await Task.sleep(for: .seconds(5))
            return try await sut.run("echo", "hello world")
        }
        try? await Task.sleep(for: .seconds(1))
        task.cancel()
        let value = try? await task.value
        XCTAssertNil(value)
    }
    
    func test_longRunningCommand_isCancelledBeforeCompletion() async {
        // Given
        let sut = EnvironmentShell()
        // When
        let task = Task<String, Error> {
            return try await sut.run("sleep", "5")
        }
        try? await Task.sleep(for: .seconds(1))
        task.cancel()
        let value = try? await task.value
        XCTAssertNil(value)
    }

}
