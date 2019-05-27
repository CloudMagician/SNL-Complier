//
//  LexcialAnalyzer.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/8.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

class LexcialAnalyzer {
    // 当前行列
    var currentLine = 0
    var currentColumn = 0
    
    // Tokens
    var Tokens = [Token]()
    
    // 扫描得出Token
    func scan(codes: String) {
        currentLine = 0
        currentColumn = 0
        Tokens.removeAll()
        var tempString : String = ""
        var tempCharacter : Character = " "
        let codess = removeComments(codes)
        let lines = codess.components(separatedBy: "\n")
        for line in lines {
            currentLine += 1
            currentColumn = 0
            let words = line.components(separatedBy: " ")
            for word in words {
                if word == "" || word == " " {
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
    
    // 去掉注释
    func removeComments(_ codes: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\{[\\s\\S]*?\\}", options: [])
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
    
    func showTokens() -> [Token] {
        return Tokens
    }
}
