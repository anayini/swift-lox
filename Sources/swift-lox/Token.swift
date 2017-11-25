//
//  Token.swift
//  swift-loxPackageDescription
//
//  Created by Arjun Nayini on 11/22/17.
//

import Foundation

/// Represents a Token that is found during the scanning phase
/// of the interpreter.  Contains information about the type of the
/// token as well as its location in the file.
public struct Token {
    let type: TokenType
    let lexeme: String
    let literal: AnyObject?
    let line: Int
    
    init(type: TokenType, lexeme: String, literal: AnyObject?, line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
    
    func toString() -> String {
        if let literal = self.literal {
            return "Type: \(self.type.rawValue) Literal: \(literal)"
        } else {
            return "Type: \(self.type.rawValue) Lexeme: \(self.lexeme)"
        }
    }
}

