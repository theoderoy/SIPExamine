// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

#if !os(macOS)
import UIKit

@MainActor
public func isSIPenabled() -> Bool {
    let alertController = UIAlertController(title: "csrutil Diagnostics Unsupported", message: "This service does not support csrutil diagnostics on this platform, so variable false will be returned. Please contact your system administrator or this service's developer for assistance.", preferredStyle: .alert)
    
    let quitAction = UIAlertAction(title: "Quit", style: .default, handler: nil)
    alertController.addAction(quitAction)
    
    if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    return false
}
#else
public func isSIPenabled() -> Bool {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["csrutil", "status"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: .utf8) else {
        return false
    }
    
    return output.contains("System Integrity Protection status: enabled.")
}
#endif
