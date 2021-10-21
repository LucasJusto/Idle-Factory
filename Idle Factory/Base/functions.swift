//
//  functions.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 21/10/21.
//

import Foundation

func doubleToString(value: Double) -> String {
        //convert devCoins or devCoinsPerSec to String using K, M, B, T, AA, AB...
        var str: String = ""
        var n: String = "0"

        if value < pow(10, 3) {
            str = ""
            n = "\(value)"
        }
        else if value < pow(10, 6) {
            str = "K"
            n = "\(value/pow(10, 3))"
        }
        else if value < pow(10, 9) {
            str = "M"
            n = "\(value/pow(10, 6))"
        }
        else if value < pow(10, 12) {
            str = "B"
            n = "\(value/pow(10, 9))"
        }
        else if value < pow(10, 15) {
            str = "T"
            n = "\(value/pow(10, 12))"
        }
        else if value < pow(10, 18) {
            str = "AA"
            n = "\(value/pow(10, 15))"
        }
        else if value < pow(10, 21) {
            str = "AB"
            n = "\(value/pow(10, 18))"
        }
        else if value < pow(10, 24) {
            str = "AC"
            n = "\(value/pow(10, 21))"
        }
        else if value < pow(10, 27) {
            str = "AD"
            n = "\(value/pow(10, 24))"
        }
        else if value < pow(10, 30) {
            str = "AE"
            n = "\(value/pow(10, 27))"
        }


        let splitedN = n.split(separator: ".")
        let nInteger: String = "\(splitedN[0])"
        var nDecimal: String = "00"
        if splitedN.count > 1  {
            nDecimal = "\(splitedN[1].prefix(2))"
        }
        return "\(nInteger).\(nDecimal)\(str)"
    }
