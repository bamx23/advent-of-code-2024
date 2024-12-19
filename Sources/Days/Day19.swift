//
//  Day19.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 19/12/2024.
//

import Foundation
import Shared

public struct Day19: Day {
    static public let number = 19

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Color: Character {
        case black = "b"
        case white = "w"
        case red = "r"
        case green = "g"
        case blue = "u"
    }

    func parse() -> (patterns: [[Color]], designs: [[Color]]) {
        let p = input.split(separator: "\n\n")
        let patterns = p[0]
            .split(separator: ",")
            .map { $0.compactMap(Color.init) }
        let designs = p[1]
            .split(separator: "\n")
            .map { $0.compactMap(Color.init) }
        return (patterns, designs)
    }

    private func match(design: [Color], patterns: [[Color]], cache: inout [[Color]: Int]) -> Int {
        if design.isEmpty { return 1 }
        if let val = cache[design] { return val }

        var aranges: Int = 0
        for pattern in patterns {
            if design.count < pattern.count { continue }
            if zip(design, pattern).contains(where: { $0 != $1 }) { continue }
            let subAranges = match(design: Array(design.dropFirst(pattern.count)), patterns: patterns, cache: &cache)
            aranges += subAranges
        }

        cache[design] = aranges
        return aranges
    }

    public func part01() -> String {
        let (patterns, designs) = parse()
        var cache: [[Color]: Int] = [:]
        let result = designs
            .filter { match(design: $0, patterns: patterns, cache: &cache) != 0 }
            .count
        return "\(result)"
    }
    
    public func part02() -> String {
        let (patterns, designs) = parse()
        var cache: [[Color]: Int] = [:]
        let result = designs
            .map { match(design: $0, patterns: patterns, cache: &cache) }
            .reduce(0, +)
        return "\(result)"
    }
}
