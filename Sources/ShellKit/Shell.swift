//
//  Shell.swift
//
//
//  Created by Antonio on 24/10/23.
//

import Foundation

public protocol Shell {
    func run(_ command: String...) async throws -> String
}
