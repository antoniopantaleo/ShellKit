import XCTest
import ShellKit

final class ZshShellTests: XCTestCase {
    
    func test_run_shellIsZsh() async throws {
        // Given
        let sut = ZshShell()
        // When
        let shell = try await sut.run("echo \"$SHELL\"")
        // Then
        XCTAssertEqual("/bin/zsh", shell)
    }
    
    func test_run_throwsErrorOnInvalidCommand() async {
        // Given
        let sut = ZshShell()
        let expectedErrorString = "zsh:1: command not found: invalid"
        // When
        do {
            let output = try await sut.run("invalid command")
            XCTFail("Expected to fail, got \(output) instead")
        } catch {
            // Then
            XCTAssertEqual(expectedErrorString, (error as NSError).domain)
        }
    }
    
    func test_run_throwsErrorOnNonUtf8Output() async {
        // Given
        let sut = ZshShell()
        let expectedError = NSError(
            domain: NSCocoaErrorDomain,
            code: NSFileReadInapplicableStringEncodingError
        )
        // When
        do {
            let output = try await sut.run("echo -n \"\\x80\"")
            XCTFail("Expected to fail, got \(output) instead")
        } catch {
            // Then
            XCTAssertEqual(expectedError, error as NSError)
        }
    }
    
    func test_run_isOnBackgroundThread() throws {
        XCTAssertTrue(Thread.isMainThread)
        // Given
        let sut = ZshShell()
        Task {
            // When
            _ = try await sut.run("echo Hello World")
            // Then
            XCTAssertFalse(Thread.isMainThread)
        }
    }

}
