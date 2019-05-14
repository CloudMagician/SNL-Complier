//
//  MyTools.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/14.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import Foundation

class MyTools {
    static func showTable(text : String) -> String {
        var resultText = text
        switch text.count {
        case 0:
            resultText += "\t\t\t\t"
        case 1:
            resultText += "\t\t\t\t"
        case 2:
            resultText += "\t\t\t\t"
        case 3:
            resultText += "\t\t\t\t"
        case 4:
            resultText += "\t\t\t"
        case 5:
            resultText += "\t\t\t"
        case 6:
            resultText += "\t\t"
        case 7:
            resultText += "\t\t"
        case 8:
            resultText += "\t\t"
        case 9:
            resultText += "\t"
        default:
            resultText += "\t"
        }
        return resultText
    }
}
