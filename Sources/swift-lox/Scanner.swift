//
//  Scanner.swift
//  swift-loxPackageDescription
//
//  Created by Arjun Nayini on 11/22/17.
//

//
//  Scanner.swift
//  swiftlox
//
//  Created by Arjun Nayini on 8/18/17.
//  Copyright © 2017 Nayini. All rights reserved.
//

import Foundation

public class Scanner {
    private static let keywords: [String: TokenType] = [
        "and"    : .and,
        "class"  : .`class`,
        "else"   : .`else`,
        "false"  : .`false`,
        "for"    : .`for`,
        "fun"    : .fun,
        "if"     : .`if`,
        "nil"    : .`nil`,
        "or"     : .or,
        "print"  : .print,
        "return" : .`return`,
        "super"  : .`super`,
        "this"   : .this,
        "true"   : .`true`,
        "var"    : .`var`,
        "while"  : .`while`,
        ]
    
    private let _source: String
    private var _tokens: [Token] = []
    private var _start = 0
    private var _current = 0
    private var _line = 1
    
    init(source: String) {
        self._source = source
    }
}

extension Scanner {
    public func scanTokens() -> [Token] {
        while !self._isAtEnd() {
            self._start = self._current
            self._scanToken()
        }
        self._tokens.append(Token(type: .eof, lexeme: "", literal: nil, line: self._line))
        return self._tokens
    }
}

extension Scanner {
    private func _isAtEnd() -> Bool {
        return self._current >= self._source.count
    }
    
    private func _advance() -> Character  {
        self._current += 1
        let index = self._source.index(self._source.startIndex, offsetBy: self._current - 1)
        return self._source[index]
    }
}

extension Scanner {
    private func _addToken(type: TokenType, literal: AnyObject? = nil) {
        let start = self._source.index(self._source.startIndex, offsetBy: self._start)
        let current = self._source.index(self._source.startIndex, offsetBy: self._current)
        let text = self._source[start..<current]
        self._tokens.append(Token(type: type, lexeme: String(text), literal: literal, line: self._line))
    }
    
    private func _scanToken() {
        let character = self._advance()
        switch character {
        case "(":
            self._addToken(type: .leftParen)
        case ")":
            self._addToken(type: .rightParen)
        case "{":
            self._addToken(type: .leftBrace)
        case "}":
            self._addToken(type: .rightBrace)
        case ",":
            self._addToken(type: .comma)
        case ".":
            self._addToken(type: .dot)
        case "-":
            self._addToken(type: .minus)
        case "+":
            self._addToken(type: .plus)
        case ";":
            self._addToken(type: .semicolon)
        case "*":
            self._addToken(type: .star)
        case "!":
            self._addToken(type: .bang)
        case "=":
            self._addToken(type: .equal)
        case "<":
            self._addToken(type: .less)
        case ">":
            self._addToken(type: .greater)
        case "/":
            if self._match(expected: "/") {
                // Start of a comment for the rest of the line
                while (self._peek() != "\n" && !self._isAtEnd()) {
                    _ = self._advance()
                }
            } else {
                self._addToken(type: .slash)
            }
            break
        case " ", "\r", "\t":
            break
        case "\n":
            self._line += 1
            break
        case "\"":
            self._string()
            break
        default:
            if self._isDigit(character: character) {
                self._number()
            } else if (self._isAlphanumeric(character: character)) {
                self._identifier()
            } else {
                Lox.error(line: self._line, message: "Unexpected Character")
            }
            break
        }
    }
}

extension Scanner {
    private func _match(expected: Character) -> Bool {
        if self._isAtEnd() { return false }
        let currentIndex = self._source.index(self._source.startIndex, offsetBy: self._current)
        if self._source[currentIndex] != expected {
            return false
        }
        self._current += 1
        return true
    }
    
    private func _peek() -> Character {
        if self._isAtEnd() { return "\0" }
        let currentIndex = self._source.index(self._source.startIndex, offsetBy: self._current)
        return self._source[currentIndex]
    }
    
    private func _peekNext() -> Character {
        if self._current + 1 >= self._source.count { return "\0" }
        let peekIndex = self._source.index(self._source.startIndex, offsetBy: self._current + 1)
        return self._source[peekIndex]
    }
    
    private func _isDigit(character: Character) -> Bool {
        return character >= "0" && character <= "9"
    }
    private func _isAlpha(character: Character) -> Bool {
        return (
            (character >= "a" && character <= "z") ||
                (character >= "A" && character <= "Z") ||
                (character == "_")
        )
    }
    
    private func _isAlphanumeric(character: Character) -> Bool {
        return self._isDigit(character: character) || self._isAlpha(character: character)
    }
}

extension Scanner {
    private func _string() {
        while self._peek() != "\"" && !self._isAtEnd() {
            if self._peek() == "\n" {
                self._line += 1
            }
            _ = self._advance()
        }
        
        // Unterminated String
        if (self._isAtEnd()) {
            Lox.error(line: self._line, message: "Error Unterminated String")
            return
        }
        
        // The closing "
        _ = self._advance()
        
        // Trim the surroudnig quotes
        let startIndex = self._source.index(self._source.startIndex, offsetBy: self._start + 1)
        let endIndex = self._source.index(self._source.startIndex, offsetBy: self._current - 1)
        let value = self._source[startIndex ..< endIndex]
        self._addToken(type: .string, literal: value as AnyObject)
    }
    
    private func _identifier() {
        while self._isAlphanumeric(character: self._peek()) {
            _ = self._advance()
        }
        
        let startIndex = self._source.index(self._source.startIndex, offsetBy: self._start )
        let endIndex = self._source.index(self._source.startIndex, offsetBy: self._current )
        let text = self._source[startIndex ..< endIndex]
        if let type = Scanner.keywords[String(text)] {
            self._addToken(type: type)
        } else {
            self._addToken(type: .identifier)
        }
    }
    
    private func _number() {
        while self._isDigit(character: self._peek()) {
            _ = self._advance()
        }
        
        // Look for fractions
        if (self._peek() == "." && _isDigit(character: self._peekNext())) {
            _ = self._advance()
        }
        
        while self._isDigit(character: self._peek()) {
            _  = self._advance()
        }
        
        let startIndex = self._source.index(self._source.startIndex, offsetBy: self._start )
        let endIndex = self._source.index(self._source.startIndex, offsetBy: self._current )
        let text = self._source[startIndex ..< endIndex]
        self._addToken(type: .number, literal: Double(text) as AnyObject)
    }
}

