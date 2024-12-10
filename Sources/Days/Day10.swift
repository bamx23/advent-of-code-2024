//
//  Day10.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 10/12/2024.
//

import Foundation
import Shared

public struct Day10: Day {
    static public let number = 10

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Int]] {
        input
            .split(separator: "\n")
            .map { l in l.compactMap(\.wholeNumberValue) }
    }
    
    public func part01() -> String {
        let map = parse()
        var result = 0
        map.iterPoses { pos, val in
            guard val == 0 else { return }

            var score = 0
            var visited: Set<Pos> = [pos]
            var queue: [Pos] = [pos]
            while !queue.isEmpty {
                let cur = queue.removeFirst()
                let curVal = map[cur]!
                map.iterPoses(around: cur, allowDiagonal: false) { neig, nVal in
                    guard nVal == curVal + 1 else { return }
                    guard !visited.contains(neig) else { return }
                    visited.insert(neig)
                    if nVal == 9 {
                        score += 1
                    } else {
                        queue.append(neig)
                    }
                }
            }

            result += score
        }
        return "\(result)"
    }
    
    public func part02() -> String {
        let map = parse()
        var result = 0
        map.iterPoses { pos, val in
            guard val == 0 else { return }

            var rate = 0
            var stack: [Pos] = [pos]
            while !stack.isEmpty {
                let cur = stack.removeLast()
                let curVal = map[cur]!
                map.iterPoses(around: cur, allowDiagonal: false) { neig, nVal in
                    guard nVal == curVal + 1 else { return }
                    if nVal == 9 {
                        rate += 1
                    } else {
                        stack.append(neig)
                    }
                }
            }

            result += rate
        }
        return "\(result)"
    }
}
