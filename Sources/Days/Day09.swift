//
//  Day09.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 09/12/2024.
//

import Foundation
import Shared

public struct Day09: Day {
    static public let number = 9

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Int] {
        input
            .split(separator: "\n")[0]
            .compactMap(\.wholeNumberValue)
    }
    
    public func part01() -> String {
        let compressed = parse()
        var map = compressed
            .enumerated()
            .flatMap { idx, val in [Int](repeating: idx.isMultiple(of: 2) ? idx / 2 : -1, count: val) }
        var (l, r) = (0, map.count - 1)
        while l < r {
            while l < r && map[l] != -1 { l += 1 }
            while l < r && map[r] == -1 { r -= 1 }
            if l < r { (map[l], map[r]) = (map[r], map[l]) }
        }
        let result = map
            .enumerated()
            .filter { $0.element > 0 }
            .map { $0.element * $0.offset }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        var compressed = parse()
        var indices = Array(0..<(compressed.count / 2 + 1))
        var idx = compressed.count - 1
        if !idx.isMultiple(of: 2) { idx -= 1 }
        var cId = idx / 2

        while idx >= 0 {
            if indices[idx / 2] != cId {
                idx -= 2
                continue
            }
            for p in stride(from: 1, to: idx, by: 2) {
                if compressed[p] >= compressed[idx] {
                    compressed[p] -= compressed[idx]
                    compressed.insert(contentsOf: [0, compressed[idx]], at: p)
                    indices.insert(indices[idx / 2], at: (p + 1) / 2)
                    idx += 2

                    indices.remove(at: idx / 2)
                    if idx == compressed.count - 1 {
                        compressed[idx - 1] += compressed[idx]
                        compressed.remove(at: idx)
                    } else {
                        compressed[idx - 1] += compressed[idx] + compressed[idx + 1]
                        compressed.removeSubrange(idx..<(idx + 2))
                    }
                    break
                }
            }
            idx -= 2
            cId -= 1
        }

        let map = compressed
            .enumerated()
            .flatMap { idx, val in [Int](repeating: idx.isMultiple(of: 2) ? indices[idx / 2] : -1, count: val) }
        let result = map
            .enumerated()
            .filter { $0.element > 0 }
            .map { $0.element * $0.offset }
            .reduce(0, +)
        return "\(result)"
    }
}
