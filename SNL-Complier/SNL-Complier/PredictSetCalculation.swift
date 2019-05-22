//
//  PredictSetCalculation.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/18.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

class PredictSetCalculation {
    var productionList = [Production]()
    var firstSet = [NonTerminalType : Set<String>]()
    var followSet = [NonTerminalType : Set<String>]()
    var predictSet = [Int : Set<String>]()
    
    init(text : String) {
        productionList.removeAll()
        firstSet.removeAll()
        followSet.removeAll()
        predictSet.removeAll()
        
        var leftText : NonTerminalType?
        
        let lines = text.components(separatedBy: "\n")
        for line in lines {
            if line.count < 2 {
                continue
            }
            var words = line.components(separatedBy: " ")
            words = words.filter{$0 != " " && $0 != ""} //闭包，去掉空格
            if words.contains("::=") {
                if let left = NonTerminalType.init(rawValue: words[0]) {
                    leftText = left
                    firstSet.updateValue(Set<String>(), forKey: leftText!)
                    followSet.updateValue(Set<String>(), forKey: leftText!)
                    words = words.filter{$0 != "::="}
                } else {
                    print("ERROR:NonTerminalType")
                    return
                }
            }
            words.remove(at: 0)
            productionList.append(Production.init(productionLeft: leftText!, productionRight: words))
        }
        
        if productionList.count > 0 {
            followSet[productionList.first!.productionLeft] = ["#"]
            for (i, _) in productionList.enumerated() {
                predictSet.updateValue(Set<String>(), forKey: i)
            }
            
            establishFirstSet()
            establishFollowSet()
            establishPredictSet()
        }
        
//        for i in firstSet.sorted(by: {$0.0.rawValue < $1.0.rawValue}) {
//            print(i.key)
//            print(i.value)
//        }
//        print("\n\n\n")
//        for i in followSet.sorted(by: {$0.0.rawValue < $1.0.rawValue}) {
//            print(i.key)
//            print(i.value)
//        }
//        print("\n\n\n")
//        for i in predictSet.sorted(by: {$0.0 < $1.0}) {
//            print(i.key)
//            print(i.value)
//        }
    }
    
    func establishFirstSet() {
        var temp = [NonTerminalType : Set<String>]()
        while temp != firstSet {
            temp = firstSet
            for nonTerminal in NonTerminalType.allCases {
                for production in productionList {
                    if production.productionLeft == nonTerminal {
                        for word in production.productionRight {
                            if let leftWord = NonTerminalType.init(rawValue: word) {
                                firstSet[nonTerminal]! = firstSet[nonTerminal]!.union(firstSet[leftWord]!)
                                if firstSet[leftWord]!.contains(null) {
                                    if word != production.productionRight.last! {
                                        firstSet[nonTerminal]!.remove(null)
                                    }
                                } else {
                                    break
                                }
                            } else {
                                firstSet[nonTerminal]!.insert(word)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func establishFollowSet() {
        var temp = [NonTerminalType : Set<String>]()
        while temp != followSet {
            temp = followSet
            for nonTerminal in NonTerminalType.allCases {
                for production in productionList {
                    var isNeed = false
                    var list = [String]()
                    for (i,word) in production.productionRight.enumerated() {
                        if word == nonTerminal.rawValue {
                            isNeed = true
                            if i == (production.productionRight.count - 1) {
                                followSet[nonTerminal]! = followSet[nonTerminal]!.union(followSet[production.productionLeft]!)
                            }
                        } else if isNeed {
                            list.append(word)
                        }
                    }
                    if !list.isEmpty {
                        var set = Set<String>()
                        for (i,word) in list.enumerated() {
                            if let leftWord = NonTerminalType.init(rawValue: word) {
                                set = set.union(firstSet[leftWord]!)
                                if firstSet[leftWord]!.contains(null) {
                                    if i < list.count - 1 {
                                        set.remove(null)
                                    }
                                } else {
                                    break
                                }
                            } else {
                                set.insert(word)
                                break
                            }
                        }
                        if set.contains(null) {
                            followSet[nonTerminal]! = followSet[nonTerminal]!.union(followSet[production.productionLeft]!)
                            set.remove(null)
                        }
                        followSet[nonTerminal]! = followSet[nonTerminal]!.union(set)
                    }
                }
            }
        }
    }
    
    func establishPredictSet() {
        for (index,production) in productionList.enumerated() {
            var list = [String]()
            for word in production.productionRight {
                list.append(word)
            }
            var set = Set<String>()
            for (i,word) in list.enumerated() {
                if let leftWord = NonTerminalType.init(rawValue: word) {
                    set = set.union(firstSet[leftWord]!)
                    if firstSet[leftWord]!.contains(null) {
                        if i < list.count - 1 {
                            set.remove(null)
                        }
                    } else {
                        break
                    }
                } else {
                    set.insert(word)
                    break
                }
            }
            if set.contains(null) {
                set.remove(null)
                predictSet[index]! = predictSet[index]!.union(followSet[production.productionLeft]!)
            }
            predictSet[index]! = predictSet[index]!.union(set)
        }
    }
    
    func showProductionList() -> [Production] {
        return productionList
    }
    
    func showPredictSet() -> [Int : Set<String>] {
        return predictSet
    }
    
    func showTable() -> [[Int]] {
        var result : [[Int]] = [[Int]](repeating: [Int](repeating: -1, count: TerminalType.allCases.count), count: NonTerminalType.allCases.count)
        for (i, set) in predictSet {
            for p in set {
                result[NonTerminalType.allCases.firstIndex(of: productionList[i].productionLeft)!][TerminalType.allCases.firstIndex(of: TerminalType.init(rawValue: p)!)!] = i
            }
        }
        return result
    }
}
