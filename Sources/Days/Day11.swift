//
//  Day11.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 11/12/2024.
//

import Foundation
import Shared
import os

public struct Day11: Day {
    static public let number = 11

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Int] {
        input
            .split(separator: "\n")[0]
            .split(separator: " ")
            .map(String.init)
            .compactMap(Int.init)
    }

    private struct CacheKey: Hashable {
        let val: Int
        let steps: Int
    }

    private func blink(val: Int, steps: Int, cache: OSAllocatedUnfairLock<[CacheKey: Int]>) -> Int {
        guard steps > 0 else { return 1 }

        if val == 0 {
            return blink(val: 1, steps: steps - 1, cache: cache)
        }

        let cacheKey = CacheKey(val: val, steps: steps)
        if let result = cache.withLock({ $0[cacheKey] }) { return result }

        var result = 0
        let str = String(val)
        if str.count.isMultiple(of: 2) {
            let (a, b) = (
                Int(str.prefix(str.count / 2))!,
                Int(str.suffix(str.count / 2))!
            )
            result = blink(val: a, steps: steps - 1, cache: cache) + blink(val: b, steps: steps - 1, cache: cache)
        } else {
            result = blink(val: val * 2024, steps: steps - 1, cache: cache)
        }

        cache.withLock { [result] in $0[cacheKey] = result }
        return result
    }

    public func part01() -> String {
        let cache = OSAllocatedUnfairLock(initialState: [CacheKey: Int]())
        let result = parse()
            .parallelCompactMap { blink(val: $0, steps: 25, cache: cache) }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let cache = OSAllocatedUnfairLock(initialState: [CacheKey: Int]())
        let result = parse()
            .parallelCompactMap { blink(val: $0, steps: 75, cache: cache) }
            .reduce(0, +)
        return "\(result)"
    }
}
