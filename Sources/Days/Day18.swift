//
//  Day18.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 18/12/2024.
//

import Foundation
import Shared

public struct Day18: Day {
    static public let number = 18

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Pos] {
        input
            .split(separator: "\n")
            .map { l in
                let p = l.split(separator: ",").map(String.init).compactMap(Int.init)
                return .init(x: p[0], y: p[1])
            }
    }

    private func dfs(walls: Set<Pos>, size: Int, shouldContinue: () -> Bool) -> Int? {
        let start = Pos(x: 0, y: 0)
        let end = Pos(x: size - 1, y: size - 1)
        var visited: Set<Pos> = walls
        visited.insert(start)
        var queue: [(Int, Pos)] = [(0, start)]
        while !queue.isEmpty && shouldContinue() {
            let (len, pos) = queue.removeFirst()
            if pos == end {
                return len
            }
            for dir in Dir.allCases {
                let next = pos + dir.delta
                guard (0..<size).contains(next.x) && (0..<size).contains(next.y) else { continue }
                guard visited.contains(next) == false else { continue }
                queue.append((len + 1, next))
                visited.insert(next)
            }
        }
        return nil
    }

    public func part01() -> String {
        let bytes = parse()
        let (size, steps) = bytes.count < 30
        ? (7, 12) // Sample
        : (71, 1024) // Task

        return "\(dfs(walls: Set(bytes.prefix(steps)), size: size, shouldContinue: { true }) ?? 0)"
    }
    
    public func part02() -> String {
        let bytes = parse()
        let size = bytes.count < 30 ? 7 : 1024

        let idx = Array(0..<bytes.count)
            .parallelBinarySearch(maxThreads: 6) { mid, tok in
                dfs(walls: Set(bytes.prefix(mid + 1)), size: size, shouldContinue: { !tok.isCanceled }) == nil
                ? .orderedDescending
                : .orderedAscending
            }

        guard let idx else { return "No solution" }
        let byte = bytes[idx]
        return "\(byte.x),\(byte.y)"
    }
}
