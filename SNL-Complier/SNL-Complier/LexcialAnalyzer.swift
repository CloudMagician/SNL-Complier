//
//  LexcialAnalyzer.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/8.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation


// Token全类型
enum lexcialType : String {
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


// Token结构
struct Token{
    var type: lexcialType
    var data: String
    var line: Int
    var column: Int
    
    init(type: lexcialType, data: String, line: Int, column : Int) {
        self.type = type
        self.data = data
        self.line = line
        self.column = column
    }
}


class LexcialAnalyzer {
    // 保留字查找
    let reservedWord:[String:lexcialType] = [
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
        "begin":    .BEGIN1,
        "end":      .END1,
        "read":     .READ,
        "write":    .WRITE,
        "array":    .ARRAY,
        "of":       .OF,
        "record":   .RECORD,
        "return":   .RETURN1,
        "integer":  .INTEGER,
        "char":     .CHAR1
    ]
    
    // 符号查找
    let symbolWord:[Character:lexcialType] = [
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
        //    ":=":lexcialType.ASSIGN,
        //    "..":lexcialType.UNDERANGE
    ]
    
    // 类型判别
    let discriminateType:[String:lexcialType] = [
        "\\d+":         .INTC,
        "\'.{1}\'":     .CHARC,
        "[a-zA-Z_][a-zA-Z_0-9]*":.ID
    ]
    
    // 当前行列
    var currentLine = 0
    var currentColumn = 0
    
    // Tokens
    var Tokens = [Token]()
    
    // 去掉注释
    func removeComments(_ codes: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\{.*?\\}", options: [])
        let result = regex.stringByReplacingMatches(in: codes, options: [], range: NSRange(location: 0, length: codes.count), withTemplate: " ")
        return result
    }
    
    // 判别单词
    func discriminateWord(_ word: String) -> Token {
        currentColumn += 1
        var data = word
        for (key, value) in reservedWord {
            if word == key {
                return Token.init(type: value, data: "", line: currentLine, column: currentColumn)
            }
        }
        for (key, value) in discriminateType {
            let regex = try! NSRegularExpression(pattern: key, options: [])
            let resultRange = regex.rangeOfFirstMatch(in: data, options: [], range: NSRange(location: 0, length: data.count))
            if resultRange == NSRange(location: 0, length: data.count) {
                if value == .CHARC {
                    data = String(data[data.index(after: data.startIndex)])
                }
                return Token.init(type: value, data: data, line: currentLine, column: currentColumn)
            }
        }
        return Token.init(type: .ERROR, data: word, line: currentLine, column: currentColumn)
    }
    
    // 扫描得出Token
    func scan(_ codes: String) {
        currentLine = 0
        currentColumn = 0
        var tempString : String = ""
        var tempCharacter : Character = " "
        let codess = removeComments(codes)
        let lines = codess.components(separatedBy: "\n")
        for line in lines {
            currentLine += 1
            currentColumn = 0
            let words = line.components(separatedBy: " ")
            for word in words {
                if word == "" {
                    continue
                }
                tempString = ""
                tempCharacter = " "
                label: for c in word {
                    switch c {
                    case ":":
                        if tempString != "" {
                            Tokens.append(discriminateWord(tempString))
                            tempString = ""
                        }
                        switch tempCharacter {
                        case ":":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                            currentColumn += 1
                            Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                            tempCharacter = " "
                        case ".":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .DOT, data: "", line: currentLine, column: currentColumn))
                            currentColumn += 1
                            Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                            tempCharacter = " "
                        default :
                            tempCharacter = ":"
                        }
                    case "=":
                        if tempString != "" {
                            Tokens.append(discriminateWord(tempString))
                            tempString = ""
                        }
                        switch tempCharacter {
                        case ":":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .ASSIGN, data: "", line: currentLine, column: currentColumn))
                        case ".":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .DOT, data: "", line: currentLine, column: currentColumn))
                            currentColumn += 1
                            Tokens.append(Token.init(type: .EQ, data: "", line: currentLine, column: currentColumn))
                        default :
                            currentColumn += 1
                            Tokens.append(Token.init(type: .EQ, data: "", line: currentLine, column: currentColumn))
                        }
                        tempCharacter = " "
                    case ".":
                        if tempString != "" {
                            Tokens.append(discriminateWord(tempString))
                            tempString = ""
                        }
                        switch tempCharacter {
                        case ":":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                            currentColumn += 1
                            Tokens.append(Token.init(type: .DOT, data: "", line: currentLine, column: currentColumn))
                            tempCharacter = " "
                        case ".":
                            currentColumn += 1
                            Tokens.append(Token.init(type: .UNDERANGE, data: "", line: currentLine, column: currentColumn))
                            tempCharacter = " "
                        default :
                            tempCharacter = "."
                        }
                    default :
                        switch tempCharacter {
                        case ":":
                            if tempString != "" {
                                Tokens.append(discriminateWord(tempString))
                                tempString = ""
                            }
                            currentColumn += 1
                            Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                        case ".":
                            if tempString != "" {
                                Tokens.append(discriminateWord(tempString))
                                tempString = ""
                            }
                            currentColumn += 1
                            Tokens.append(Token.init(type: .DOT, data: "", line: currentLine, column: currentColumn))
                        default :
                            for (key, value) in symbolWord {
                                if c == key {
                                    if tempString != "" {
                                        Tokens.append(discriminateWord(tempString))
                                        tempString = ""
                                    }
                                    currentColumn += 1
                                    Tokens.append(Token.init(type: value, data: "", line: currentLine, column: currentColumn))
                                    continue label
                                }
                            }
                            tempString.append(c)
                        }
                        tempCharacter = " "
                    }
                }
                if tempString != "" {
                    Tokens.append(discriminateWord(tempString))
                }
                switch tempCharacter {
                case ":":
                    currentColumn += 1
                    Tokens.append(Token.init(type: .COLON, data: "", line: currentLine, column: currentColumn))
                case ".":
                    currentColumn += 1
                    Tokens.append(Token.init(type: .DOT, data: "", line: currentLine, column: currentColumn))
                default :
                    break
                }
            }
        }
    }
    
    func showTokens() -> [Token] {
        return Tokens
    }
}
