//
//  MorseCode.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 10/11/22.
//

import Foundation

class MorseCode : ObservableObject {
    var morseList : [CodeType] = []
    let morseDict : [String : String] = [".-": "A",
                                         "-...": "B",
                                         "-.-.": "C",
                                         "-..": "D",
                                         ".": "E",
                                         "..-.": "F",
                                         "--.": "G",
                                         "....": "H",
                                         "..": "I",
                                         ".---": "J",
                                         "-.-": "K",
                                         ".-..": "L",
                                         "--": "M",
                                         "-.": "N",
                                         "---": "O",
                                         ".--.": "P",
                                         "--.-": "Q",
                                         ".-.": "R",
                                         "...": "S",
                                         "-": "T",
                                         "..-": "U",
                                         "...-": "V",
                                         ".--": "W",
                                         "-..-": "X",
                                         "-.--": "Y",
                                         "--..": "Z",
                                         ".----": "1",
                                         "..---": "2",
                                         "...--": "3",
                                         "....-": "4",
                                         ".....": "5",
                                         "-....": "6",
                                         "--...": "7",
                                         "---..": "8",
                                         "----.": "9",
                                         "-----": "0",
                                         ]
    @Published var currString : String = ""
    @Published var translatedString: String = ""
    
    func addChar(_ toAdd : String) {
        print(currString)
//        if let addList = CodeType(rawValue: toAdd) {
//            morseList.append(addList)
//        }
        if (toAdd == CodeType.charSpace.rawValue) {
            translate();
        } else if (toAdd == CodeType.wordSpace.rawValue) {
            translatedString += " "
        } else {
            currString += toAdd;
        }
       // print(currString)
    }
    
    func translate() {
        translatedString += morseDict[currString] ?? ""
        currString = ""
        print(translatedString)
    }
    
    
    enum CodeType : String, CaseIterable {
        case dot = "."
        case dash = "-"
        case charSpace = "&"
        case wordSpace = " "
    }
}


