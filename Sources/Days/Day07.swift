//
//  Day07.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 07/12/2024.
//

import Foundation
import Shared

public struct Day07: Day {
    static public let number = 7

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    struct Line {
        var target: Int
        var nums: [Int]
    }

    func parse() -> [Line] {
        input
            .split(separator: "\n")
            .map { l in
                let p = l.split(separator: ":")
                return .init(
                    target: Int(p[0])!,
                    nums: p[1].split(separator: " ")
                        .map(String.init)
                        .compactMap(Int.init)
                )
            }
    }
    
    public func part01() -> String {
        let result = parse()
            .parallelCompactMap { $0.isPossiblePart1 ? $0 : nil }
            .map(\.target)
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let result = parse()
            .parallelCompactMap { $0.isPossiblePart2 ? $0 : nil }
            .map(\.target)
            .reduce(0, +)
        return "\(result)"
    }
}

private extension Day07.Line {
    private func isPossible(val: Int, start: Int, allowConcat: Bool) -> Bool {
        if start == nums.count {
            return target == val
        }
        if val > target {
            // All operators are guaranteed to not decreease `val`.
            return false
        }
        let next = nums[start]
        return isPossible(val: val + next, start: start + 1, allowConcat: allowConcat)
        || isPossible(val: val * next, start: start + 1, allowConcat: allowConcat)
        || allowConcat && isPossible(val: Int(String(val) + String(next))!, start: start + 1, allowConcat: true)
    }

    var isPossiblePart1: Bool {
        guard nums.count != 0 else { return false }
        return isPossible(val: nums[0], start: 1, allowConcat: false)
    }

    var isPossiblePart2: Bool {
        guard nums.count != 0 else { return false }
        return isPossible(val: nums[0], start: 1, allowConcat: true)
    }
}
