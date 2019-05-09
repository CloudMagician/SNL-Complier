//
//  LexcialAnalyzer.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/8.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

// TOKEN 种类
enum lexcialType {
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
    case BEGIN1
    case END1
    case READ
    case WRITE
    case ARRAY
    case OF
    case RECORD
    case RETURN1
    case INTEGER
    case CHAR1
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

// 保留字查找
var reservedWord:[String:lexcialType] = [
    "program":lexcialType.PROGRAM,
    "procedure":lexcialType.PROCEDURE,
    "type":lexcialType.TYPE,
    "var":lexcialType.VAR,
    "if":lexcialType.IF,
    "then":lexcialType.THEN,
    "else":lexcialType.ELSE,
    "fi":lexcialType.FI,
    "while":lexcialType.WHILE,
    "do":lexcialType.DO,
    "endwh":lexcialType.ENDWH,
    "begin":lexcialType.BEGIN1,
    "end":lexcialType.END1,
    "read":lexcialType.READ,
    "write":lexcialType.WRITE,
    "array":lexcialType.ARRAY,
    "of":lexcialType.OF,
    "record":lexcialType.RECORD,
    "return":lexcialType.RETURN1,
    "integer":lexcialType.INTEGER,
    "char":lexcialType.CHAR1
]
