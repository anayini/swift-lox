//
//  TokenType.swift
//  swift-loxPackageDescription
//
//  Created by Arjun Nayini on 11/22/17.
//

import Foundation

public enum TokenType: String {
    case leftParen
    case rightParen
    
    case leftBrace
    case rightBrace
    
    case comma
    case dot
    case minus
    case plus
    case semicolon
    case slash
    case star
    
    case bang
    case bangEqual
    case equal
    case equalEqual
    case greater
    case greaterEqual
    case less
    case lessEqual
    
    // Literals
    case identifier
    case string
    case number
    
    // Keywords
    case and
    case `class`
    case `else`
    case `false`
    case fun
    case `for`
    case `if`
    case `nil`
    case or
    case print
    case `return`
    case `super`
    case this
    case `true`
    case `var`
    case `while`
    
    case eof
}

