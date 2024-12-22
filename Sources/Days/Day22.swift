//
//  Day22.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 22/12/2024.
//

import Foundation
import Shared

public struct Day22: Day {
    static public let number = 22

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Int] {
        input
            .split(separator: "\n")
            .map(String.init)
            .compactMap(Int.init)
    }

    public func part01() -> String {
        let result = parse()
            .parallelCompactMap { initVal in
                var val = initVal
                for _ in 0..<2000 {
                    val = val.next
                }
                return val
            }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let nums = parse()

        let seqs: [[[Int]: Int]] = nums.map { num in
            var result = [[Int]: Int]()
            var val = num
            var vDig = val % 10
            var hist: [Int] = []
            for _ in 0..<2000 {
                let next = val.next
                let nDig = next % 10

                hist.append(nDig - vDig)
                if hist.count == 4 {
                    if result[hist] == nil {
                        result[hist] = nDig
                    }
                    hist.removeFirst()
                }
                
                val = next
                vDig = nDig
            }
            return result
        }

        let result = Set(seqs.flatMap(\.keys))
            .parallelCompactMap { seq in
                seqs
                    .compactMap { $0[seq] }
                    .reduce(0, +)
            }
            .max()!
        return "\(result)"
    }
}

private extension Int {
    var next: Int {
        var val = self
        val = ((val * 64) ^ val) % 16777216
        val = ((val / 32) ^ val) % 16777216
        val = ((val * 2048) ^ val) % 16777216
        return val
    }
}
