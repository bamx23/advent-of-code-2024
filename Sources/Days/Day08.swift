//
//  Day08.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 08/12/2024.
//

import Foundation
import Shared
import Algorithms

public struct Day08: Day {
    static public let number = 8

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Character]] {
        input
            .split(separator: "\n")
            .map(Array.init)
    }

    private func antenas(for map: [[Character]]) -> [Character:[Pos]] {
        map
            .enumerated()
            .flatMap { (y, l) -> [(Character, Pos)] in
                l.enumerated().compactMap { (x, c) in
                    if c == "." { return nil }
                    return (c, Pos(x: x, y: y))
                }
            }
            .reduce(into: [:]) { $0[$1.0, default: []] += [$1.1] }
    }

    private func enumeratePairs(antenas: [Character:[Pos]], proc: (Pos, Pos) -> Void) {
        for (_, poses) in antenas {
            for p in poses.combinations(ofCount: 2) {
                proc(p[0], p[1])
            }
        }
    }

    public func part01() -> String {
        let map = parse()
        let antenas = antenas(for: map)
        var antinodes: Set<Pos> = []
        enumeratePairs(antenas: antenas) { a, b in
            let diff = a - b
            for an in [a + diff, b - diff] {
                if map[an] != nil { antinodes.insert(an) }
            }
        }
        return "\(antinodes.count)"
    }
    
    public func part02() -> String {
        let map = parse()
        let antenas = antenas(for: map)
        var antinodes: Set<Pos> = []
        enumeratePairs(antenas: antenas) { a, b in
            let diff = a - b
            let start = a - diff * map.count
            for k in 0...(map.count * 2) {
                let an = start + diff * k
                if map[an] != nil { antinodes.insert(an) }
            }
        }
        return "\(antinodes.count)"
    }
}
