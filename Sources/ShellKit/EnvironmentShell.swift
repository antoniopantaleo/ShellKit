//
//  EnvironmentShell.swift
//
//
//  Created by Antonio on 24/10/23.
//

import Foundation

public final class EnvironmentShell: Shell {
    
    private static let COMMAND_OK_CODE: Int = 0
    private static let encodingError = NSError(
        domain: NSCocoaErrorDomain,
        code: NSFileReadInapplicableStringEncodingError
    )
    
    public init() {}
    
    @discardableResult
    public func run(_ command: String...) async throws -> String {
        let process = Process()
        
        let pipe = Pipe()
        process.qualityOfService = .userInitiated
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = command
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.standardInput = nil
        
        return try await withTaskCancellationHandler {
            let task = Task.detached {
                var output: String = ""
                try process.run()
                let bytes = pipe.fileHandleForReading.bytes
                while process.isRunning {
                    for try await byte in bytes {
                        let data = Data([byte])
                        guard let chunk = String(data: data, encoding: .utf8) else { throw Self.encodingError }
                        output += chunk
                    }
                }
                output = output.trimmingCharacters(in: .newlines)
                guard process.terminationStatus == Self.COMMAND_OK_CODE else {
                    throw NSError(domain: output, code: Int(process.terminationStatus))
                }
                return output
            }
            return try await task.value
        } onCancel: {
            process.terminate()
        }
    }
}
