//
//  Lox.swift
//  swift-loxPackageDescription
//
//  Created by Arjun Nayini on 11/22/17.
//

import Foundation

public class Lox {
    static var hadError = false
    
    public static func run() {
        let arguments = CommandLine.arguments
        // CommandLine.arguments always has a first
        // argument of the path to the executable
        switch arguments.count {
        case 1:
            // No user supplied argument
            // just run the REPL
            runPrompt()
        case 2:
            runFile(filename: arguments[0])
        default:
            print("Usage: swiftlox [script])")
        }
    }

    static func error(line: Int, message: String) {
        self._report(line: line, location: "", message: message)
    }
    
    static private func _report(line: Int, location: String, message: String) {
        print("[line \(line)] Error \(location) : \(message)")
    }
    
    static func runPrompt() {
        print("runPrompt")
    }
    
    static func runFile(filename: String) {
        print("runFile \(filename)")
    }
    
    public static func run(source: String) {
        let scanner = Scanner(source: source)
        let tokens = scanner.scanTokens()
        
        for token in tokens {
            print(token.toString())
        }
    }
}

