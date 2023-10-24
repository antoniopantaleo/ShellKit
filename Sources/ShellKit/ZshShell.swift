//
//  ZshShell.swift
//  
//
//  Created by Antonio on 24/10/23.
//

import Foundation

public struct ZshShell: Shell {
    
    private var COMMAND_OK_CODE: Int { 0 }
    private var encodingError: NSError {
        NSError(
            domain: NSCocoaErrorDomain,
            code: NSFileReadInapplicableStringEncodingError
        )
    }
    
    public init() {}
    
    @discardableResult
    public func run(_ command: String) async throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.qualityOfService = .userInitiated
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try task.run()
        let bytes = pipe.fileHandleForReading.bytes
        var output = ""
        
        while task.isRunning {
            for try await byte in bytes {
                let data = Data([byte])
                guard let chunk = String(data: data, encoding: .utf8) else { throw encodingError }
                output += chunk
            }
        }
        
        output = output.trimmingCharacters(in: .newlines)
        
        if task.terminationStatus != COMMAND_OK_CODE  {
            let errorCode = Int(task.terminationStatus)
            throw NSError(domain: output, code: errorCode)
        }
        
        return output
    }
}
