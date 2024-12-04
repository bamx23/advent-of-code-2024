//
//  Day04.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 04/12/2024.
//

import Foundation
import Shared
import Algorithms

public struct Day04: Day {
    static public let number = 4

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Character]] {
        input
            .split(separator: "\n")
            .map(Array.init)
    }

    public func part01() -> String {
        let map = parse()
        let (h, w) = (map.count, map.first!.count)

        let searchDirs: [Pos] = product([-1, 0, 1], [-1, 0, 1])
            .filter { !($0.0 == 0 && $0.1 == 0) }
            .map { .init(x: $0.0, y: $0.1) }
        let searchWord: [Character] = ["X", "M", "A", "S"]

        var count = 0
        for y in 0..<h {
            for x in 0..<w {
                if map[y][x] != searchWord.first! { continue }
                let pos = Pos(x: x, y: y)
                for dir in searchDirs {
                    var found = true
                    for (idx, ch) in searchWord.enumerated().dropFirst() {
                        if map.at(pos + dir * idx) != ch {
                            found = false
                            break
                        }
                    }
                    if found { count += 1 }
                }
            }
        }
        return "\(count)"
    }
    
    public func part02() -> String {
        let map = parse()
        let (h, w) = (map.count, map.first!.count)

        let expected: Set<Character> = Set(["M", "S"])

        var count = 0
        for y in 0..<h {
            for x in 0..<w {
                if map[y][x] != "A" { continue }
                let pos = Pos(x: x, y: y)
                let a = Set([
                    map.at(pos + .init(x: -1, y: -1)),
                    map.at(pos + .init(x: 1, y: 1))
                ])
                let b = Set([
                    map.at(pos + .init(x: 1, y: -1)),
                    map.at(pos + .init(x: -1, y: 1))
                ])
                if a == b && a == expected { count += 1 }
            }
        }
        return "\(count)"
    }
}
