//
//  Day01.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 01/12/2024.
//

import Foundation
import Shared

public struct Day01: Day {
    static public let number = 1

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> ([Int], [Int]) {
        let pairs = input
            .split(separator: "\n")
            .map { l in l.split(separator: " ").map(String.init).compactMap(Int.init) }
        return (pairs.compactMap(\.first), pairs.compactMap(\.last))
    }
    
    public func part01() -> String {
        var (a, b) = parse()
        a.sort()
        b.sort()
        let result = zip(a, b)
            .map { abs($0 - $1) }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let (a, b) = parse()
        let result = a
            .map { x in x * b.count(where: { $0 == x }) }
            .reduce(0, +)
        return "\(result)"
    }
}
