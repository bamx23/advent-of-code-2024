//
//  Day03.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 03/12/2024.
//

import Foundation
import Shared

public struct Day03: Day {
    static public let number = 3

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> String {
        input
    }
    
    public func part01() -> String {
        let result = parse()
            .matches(of: #/mul\((\d+),(\d+)\)/#)
            .map { Int(String($0.1))! * Int(String($0.2))! }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        var isEnabled = true
        var result = 0
        for match in parse().matches(of: #/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/#) {
            switch match.0.prefix(3) {
            case "do(":
                isEnabled = true
            case "don":
                isEnabled = false
            default:
                if isEnabled {
                    result += Int(String(match.1!))! * Int(String(match.2!))!
                }
            }
        }
        return "\(result)"
    }
}
