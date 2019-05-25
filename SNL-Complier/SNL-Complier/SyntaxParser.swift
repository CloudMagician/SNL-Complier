//
//  SyntaxParser.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/22.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

class SyntaxParser {
    var Tokens = [Token]()
    var TokensIndex = 0
    var ProductionList = [Production]()
    var LLTable = [[Int]]()
    var Ps = [Production]()
    var PsIndex = 0
    var root : Node?
    var errorString : String?
    
    init(Tokens : [Token], ProductionList : [Production], LLTable : [[Int]]) {
        self.Tokens = Tokens
        self.ProductionList = ProductionList
        self.LLTable = LLTable
        
        productionListAnalyze()
        buildTree()
    }
    
    func productionListAnalyze() {
        if let _ = errorString {
            return
        }
        var S = [String]()
        if let start = ProductionList.first {
            S.append(start.productionLeft.rawValue)
            var index = 0
            while !S.isEmpty {
                let s = S.last!
                if index < Tokens.count {
                    if let nt = NonTerminalType.init(rawValue: s) {
                        let i = LLTable[NonTerminalType.allCases.firstIndex(of: nt)!][TerminalType.allCases.firstIndex(of: Tokens[index].type)!]
                        if i > -1 {
                            Ps.append(ProductionList[i])
                            S.removeLast(1)
                            S += ProductionList[i].productionRight.reversed()
                        } else {
                            errorString = "ERROR_Production: Tokens[\(index)] AND \(s) HAVE NO PRODUCTION"
                            return
                        }
                    } else if let tt = TerminalType.init(rawValue: s) {
                        if Tokens[index].type == tt {
                            S.removeLast(1)
                            index += 1
                        } else {
                            errorString = "ERROR_Match: Tokens[\(index)] AND \(s) DO NOT MATCH"
                            return
                        }
                    } else {
                        S.removeLast(1)
                    }
                } else {
                    errorString = "ERROR_Tokens: Tokens NOT ENOUGH"
                    return
                }
            }
        }
    }
    
    func dfsBuildTree(node : Node) {
        if let _ = errorString {
            return
        }
        for i in Ps[PsIndex].productionRight {
            if let t = TerminalType.init(rawValue: i) {
                node.children.append(Node.init(parentNode: node, children: [Node](), tType: t, nType: nil, data: ""))
            } else if let t = NonTerminalType.init(rawValue: i) {
                node.children.append(Node.init(parentNode: node, children: [Node](), tType: nil, nType: t, data: ""))
            } else if i == null{
            } else {
                errorString = "ERROR_Production: PRODUCTION ERROR"
                return
            }
        }
        PsIndex += 1
        for i in node.children {
            if let _ = i.tType {
                i.data = Tokens[TokensIndex].data
                TokensIndex += 1
            } else {
                dfsBuildTree(node: i)
            }
        }
    }
    
    func buildTree() {
        if let _ = errorString {
            return
        }
        if Ps.count < 1 {
            return
        }
        root = Node.init(parentNode: nil, children: [Node](), tType: nil, nType: Ps.first!.productionLeft, data: "")
        for i in Ps.first!.productionRight {
            if let t = TerminalType.init(rawValue: i) {
                root!.children.append(Node.init(parentNode: root, children: [Node](), tType: t, nType: nil, data: ""))
            } else if let t = NonTerminalType.init(rawValue: i) {
                root!.children.append(Node.init(parentNode: root, children: [Node](), tType: nil, nType: t, data: ""))
            } else {
                errorString = "ERROR_Production: PRODUCTION ERROR"
                return
            }
        }
        TokensIndex = 0
        PsIndex = 1
        for child in root!.children {
            if let _ = child.nType {
                dfsBuildTree(node: child)
            }
        }
    }
    
    func showNode(lftstr : String, append : String, node : Node) -> String {
        var b = append
        if let t = node.tType {
            b += t.rawValue
        } else if let t = node.nType {
            b += t.rawValue
        }
        if node.data != "" {
            b += "(" + node.data + ")"
        }
        b += "\n"
        
        if node.children.count > 0 {
            for (i, child) in node.children.enumerated() {
                if i == node.children.count - 1 {
                    b += lftstr + showNode(lftstr: lftstr, append: "|-", node: child)
                } else {
                    b += lftstr + showNode(lftstr: lftstr + "| ", append: "|-", node: child)
                }
            }
        }
        
        return b
    }
    
    func showTree() -> String {
        if let e = errorString {
            return e
        } else {
            return showNode(lftstr: "", append: "", node: root!)
        }
    }
}
