# ShellKit

![](https://img.shields.io/badge/swift-5.7-orange?logo=swift&logoColor=white&style=flat-square)
![](https://img.shields.io/badge/MacOS-12+-white?logo=apple&logoColor=white&style=flat-square)
![](https://img.shields.io/github/license/antoniopantaleo/ShellKit?style=flat-square&color=red)
[![](https://img.shields.io/github/actions/workflow/status/antoniopantaleo/ShellKit/test.yml?branch=master&label=test&style=flat-square&logo=github)](https://github.com/antoniopantaleo/ShellKit/actions/workflows/test.yml)
![](https://img.shields.io/codecov/c/github/antoniopantaleo/ShellKit?style=flat-square&logo=codecov&logoColor=white)

> *Execute terminal commands with ease and efficiency*

<p align="center">
<img alt="ShellKit Logo" src="https://github.com/antoniopantaleo/ShellKit/assets/46167308/83d69733-5f14-4bdd-b58c-2e4928f73c97" width="30%"/>
</p>

ShellKit is a Swift package designed for macOS that allows you to execute terminal commands asynchronously and in the background. With its memory-optimized approach, ShellKit provides a seamless experience for running terminal commands while minimizing resource usage.

## Usage

To use ShellKit in your macOS project, follow these steps:

1. Add ShellKit as a dependency in your `Package.swift` file:
    
    ```swift
    dependencies: [
        .package(url: "https://github.com/antoniopantaleo/ShellKit.git", from: "2.0.0")
    ]
    
    ```
    
2. Import the ShellKit module in your Swift file:
    
    ```swift
    import ShellKit
    ```
    
3. Start running terminal commands asynchronously using the `run` method:
    
    ```swift
    func listFiles() async throws -> String {
        let shell: Shell = EnvironmentShell()
        let files = try await shell.run("ls", "-a")
        return files
    }
    ```

## License

ShellKit is released under the [MIT License](https://opensource.org/licenses/MIT).
