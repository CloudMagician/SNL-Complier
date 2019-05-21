//
//  TypeDefinition.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/19.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

// 终极符全类型
enum TerminalType : String, CaseIterable {
    // 特殊单词符号
    case ENDFILE
    case ERROR
    // 保留字
    case PROGRAM
    case PROCEDURE
    case TYPE
    case VAR
    case IF
    case THEN
    case ELSE
    case FI
    case WHILE
    case DO
    case ENDWH
    case BEGIN
    case END
    case READ
    case WRITE
    case ARRAY
    case OF
    case RECORD
    case RETURN
    case INTEGER
    case CHAR
    // 多字符单词
    case ID
    case INTC
    case CHARC
    // 符号
    case ASSIGN
    case EQ
    case LT
    case PLUS
    case MINUS
    case TIMES
    case OVER
    case LPAREN
    case RPAREN
    case DOT
    case COLON
    case SEMI
    case COMMA
    case LMIDPAREN
    case RMIDPAREN
    case UNDERANGE
}

// 非终极符全类型
enum NonTerminalType : String, CaseIterable {
    // 特殊单词符号
    case ENDFILE
    case ERROR
    // 保留字
    case PROGRAM
    case PROCEDURE
    case TYPE
    case VAR
    case IF
    case THEN
    case ELSE
    case FI
    case WHILE
    case DO
    case ENDWH
    case BEGIN
    case END
    case READ
    case WRITE
    case ARRAY
    case OF
    case RECORD
    case RETURN
    case INTEGER
    case CHAR
    // 多字符单词
    case ID
    case INTC
    case CHARC
    // 符号
    case ASSIGN
    case EQ
    case LT
    case PLUS
    case MINUS
    case TIMES
    case OVER
    case LPAREN
    case RPAREN
    case DOT
    case COLON
    case SEMI
    case COMMA
    case LMIDPAREN
    case RMIDPAREN
    case UNDERANGE
}

// Token结构
struct Token{
    var type: TerminalType
    var data: String
    var line: Int
    var column: Int
    
    init(type: TerminalType, data: String, line: Int, column : Int) {
        self.type = type
        self.data = data
        self.line = line
        self.column = column
    }
}

// 保留字查找
let reservedWord:[String:TerminalType] = [
    "program":  .PROGRAM,
    "procedure":.PROCEDURE,
    "type":     .TYPE,
    "var":      .VAR,
    "if":       .IF,
    "then":     .THEN,
    "else":     .ELSE,
    "fi":       .FI,
    "while":    .WHILE,
    "do":       .DO,
    "endwh":    .ENDWH,
    "begin":    .BEGIN,
    "end":      .END,
    "read":     .READ,
    "write":    .WRITE,
    "array":    .ARRAY,
    "of":       .OF,
    "record":   .RECORD,
    "return":   .RETURN,
    "integer":  .INTEGER,
    "char":     .CHAR
]

// 符号查找
let symbolWord:[Character:TerminalType] = [
    "=":.EQ,
    "<":.LT,
    "+":.PLUS,
    "-":.MINUS,
    "*":.TIMES,
    "/":.OVER,
    "(":.LPAREN,
    ")":.RPAREN,
    ".":.DOT,
    ":":.COLON,
    ";":.SEMI,
    ",":.COMMA,
    "[":.LMIDPAREN,
    "]":.RMIDPAREN,
    //    ":=":TerminalType.ASSIGN,
    //    "..":TerminalType.UNDERANGE
]

// 类型判别
let discriminateType:[String:TerminalType] = [
    "\\d+":         .INTC,
    "\'.{1}\'":     .CHARC,
    "[a-zA-Z_][a-zA-Z_0-9]*":.ID
]

// 产生式
struct Production {
    var productionLeft = ""
    var productionRight = [String]()
    
    init(productionLeft : String, productionRight : [String]) {
        self.productionLeft = productionLeft
        self.productionRight = productionRight
    }
}
