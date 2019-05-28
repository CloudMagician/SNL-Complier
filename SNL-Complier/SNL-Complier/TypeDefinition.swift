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
    case Program
    case ProgramHead
    case ProgramName
    case DeclarePart
    case TypeDec
    case TypeDeclaration
    case TypeDecList
    case TypeDecMore
    case TypeId
    case TypeName
    case BaseType
    case StructureType
    case ArrayType
    case Low
    case Top
    case RecType
    case FieldDecList
    case FieldDecMore
    case IdList
    case IdMore
    case VarDec
    case VarDeclaration
    case VarDecList
    case VarDecMore
    case VarIdList
    case VarIdMore
    case ProcDec
    case ProcDeclaration
    case ProcDecMore
    case ProcName
    case ParamList
    case ParamDecList
    case ParamMore
    case Param
    case FormList
    case FidMore
    case ProcDecPart
    case ProcBody
    case ProgramBody
    case StmList
    case StmMore
    case Stm
    case AssCall
    case AssignmentRest
    case ConditionalStm
    case LoopStm
    case InputStm
    case Invar
    case OutputStm
    case ReturnStm
    case CallStmRest
    case ActParamList
    case ActParamMore
    case RelExp
    case OtherRelE
    case Exp
    case OtherTerm
    case Term
    case OtherFactor
    case Factor
    case Variable
    case VariMore
    case FieldVar
    case FieldVarMore
    case CmpOp
    case AddOp
    case MultOp   
}

// 产生式中空的表示方式
let null = "ε"

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
    var productionLeft : NonTerminalType
    var productionRight = [String]()
    
    init(productionLeft : NonTerminalType, productionRight : [String]) {
        self.productionLeft = productionLeft
        self.productionRight = productionRight
    }
}

// 语法树节点
class Node {
    var parentNode : Node?
    var children = [Node]()
    var tType : TerminalType?
    var nType : NonTerminalType?
    var data = ""
    
    init(parentNode : Node?, children : [Node], tType : TerminalType?, nType : NonTerminalType?, data : String) {
        self.parentNode = parentNode
        self.children = children
        self.tType = tType
        self.nType = nType
        self.data = data
    }
}

// 符号表表示
