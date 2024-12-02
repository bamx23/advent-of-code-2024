//
//  Day02.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 02/12/2024.
//

import Foundation
import Shared

public struct Day02: Day {
    static public let number = 2

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Int]] {
        input
            .split(separator: "\n")
            .map { l in l.split(separator: " ").map(String.init).compactMap(Int.init) }
    }
    
    public func part01() -> String {
        let result = parse().count(where: { $0.isSafe })
        return "\(result)"
    }
    
    public func part02() -> String {
        let result = parse().count(where: { $0.isAlmostSafe })
        return "\(result)"
    }
}

private extension Array where Element == Int {
    private func check(isInc: Bool, from start: Int = 0, allowRemoval: Bool = false) -> Bool {
        var allowRemoval = allowRemoval
        var idx = start
        var nextIdx = idx + 1
        while nextIdx < count {
            if isInc == (self[idx] < self[nextIdx]) {
                let delta = abs(self[idx] - self[nextIdx])
                if delta >= 1 && delta <= 3 {
                    idx = nextIdx
                    nextIdx += 1
                    continue
                }
            }

            if !allowRemoval { return false }
            allowRemoval = false
            nextIdx += 1
        }
        return true
    }

    var isSafe: Bool {
        check(isInc: true) || check(isInc: false)
    }

    var isAlmostSafe: Bool {
        check(isInc: true, from: 0, allowRemoval: true)
        || check(isInc: false, from: 0, allowRemoval: true)
        || check(isInc: true, from: 1, allowRemoval: false)
        || check(isInc: false, from: 1, allowRemoval: false)
    }
}
