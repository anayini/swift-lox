//
//  Token.swift
//  swift-loxPackageDescription
//
//  Created by Arjun Nayini on 11/22/17.
//

import Foundation

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
            return "\(self.type.rawValue) \(self.lexeme) \(literal)"
        } else {
            return "\(self.type.rawValue) \(self.lexeme)"
        }
    }
}

