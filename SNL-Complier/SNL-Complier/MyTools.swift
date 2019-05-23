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
        case 0,1,2,3:
            resultText += "\t\t\t\t"
        case 4,5,6,7:
            resultText += "\t\t\t"
        case 8,9,10,11:
            resultText += "\t\t"
        default:
            resultText += "\t"
        }
        return resultText
    }
}
