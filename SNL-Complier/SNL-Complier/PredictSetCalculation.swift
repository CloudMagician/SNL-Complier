//
//  PredictSetCalculation.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/18.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

struct Production {
    var productionLeft = ""
    var productionRight = [String]()
    
    init(productionLeft : String, productionRight : [String]) {
        self.productionLeft = productionLeft
        self.productionRight = productionRight
    }
}

class PredictSetCalculation {
    let null = "ε"  //空的表示方式
    
    var productionList = [Production]()
    var nonTerminalSet = Set<String>()
    var firstSet = [String : Set<String>]()
    var followSet = [String : Set<String>]()
    var predictSet = [Int : Set<String>]()
    
    init(text : String) {
        productionList.removeAll()
        var leftText = ""
        
        let lines = text.components(separatedBy: "\n")
        for line in lines {
            if line.count < 2 {
                continue
            }
            var words = line.components(separatedBy: " ")
            words = words.filter{$0 != " " && $0 != ""} //闭包，去掉空格
            if words.contains("::=") {
                leftText = words[0]
                nonTerminalSet.insert(leftText)
                firstSet.updateValue(Set<String>(), forKey: leftText)
                followSet.updateValue(Set<String>(), forKey: leftText)
                words = words.filter{$0 != "::="}
            }
            words.remove(at: 0)
            productionList.append(Production.init(productionLeft: leftText, productionRight: words))
        }
        
        leftText = productionList.first!.productionLeft
        followSet.updateValue(["#"], forKey: leftText)
        var i = 0
        for _ in productionList {
            predictSet.updateValue(Set<String>(), forKey: i)
            i += 1
        }
        
        establishFirstSet()
        establishFollowSet()
        establishPredictSet()
    }
    
    func establishFirstSet() {
        var temp = [String : Set<String>]()
        while temp != firstSet {
            temp = firstSet
            for nonTerminal in nonTerminalSet {
                for production in productionList {
                    if production.productionLeft == nonTerminal {
                        for word in production.productionRight {
                            if nonTerminalSet.contains(word) {
                                firstSet[nonTerminal]! = firstSet[nonTerminal]!.union(firstSet[word]!)
                                if (firstSet[word]!.contains(null)) && (word == production.productionRight.last!) {
                                    firstSet[nonTerminal]!.remove(null)
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
        var temp = [String : Set<String>]()
        while temp != followSet {
            temp = followSet
            for nonTerminal in nonTerminalSet {
                for production in productionList {
                    var isNeed = false
                    var list = [String]()
                    for (i,word) in production.productionRight.enumerated() {
                        if word == nonTerminal {
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
                            if nonTerminalSet.contains(word){
                                set = set.union(firstSet[word]!)
                                if firstSet[word]!.contains(null) {
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
                if nonTerminalSet.contains(word){
                    set = set.union(firstSet[word]!)
                    if firstSet[word]!.contains(null) {
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
                predictSet[index]! = predictSet[index]!.union(set)
                predictSet[index]! = predictSet[index]!.union(followSet[production.productionLeft]!)
            } else {
                predictSet[index]! = predictSet[index]!.union(set)
            }
        }
    }
    
    func showProductionList() -> [Production] {
        return productionList
    }
    
    func showPredictSet() -> [Int : Set<String>] {
        return predictSet
    }
}
