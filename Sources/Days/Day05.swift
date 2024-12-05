//
//  Day05.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 05/12/2024.
//

import Foundation
import Shared

public struct Day05: Day {
    static public let number = 5
    static let maxSize = 100

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> (map: [[Int]], samples: [[Int]]) {
        let pair = input.split(separator: "\n\n")
        return (
            pair[0]
                .split(separator: "\n")
                .map { $0.split(separator: "|").map(String.init).compactMap(Int.init) }
                .reduce(into: [[Int]](repeating: [Int](repeating: 0, count: Self.maxSize), count: Self.maxSize)) { r, p in
                    r[p[0]][p[1]] = -1
                    r[p[1]][p[0]] = 1
                }
            ,
            pair[1]
                .split(separator: "\n")
                .map { $0.split(separator: ",").map(String.init).compactMap(Int.init) }
        )
    }

    private func isCorrect(_ sample: [Int], _ map: [[Int]]) -> Bool {
        for i in 0..<(sample.count - 1) {
            for j in (i+1)..<sample.count {
                if map[sample[i]][sample[j]] > 0 {
                    return false
                }
            }
        }
        return true
    }

    public func part01() -> String {
        let (map, samples) = parse()
        let result = samples
            .filter { isCorrect($0, map) }
            .map { $0[$0.count / 2] }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let (map, samples) = parse()
        let result = samples
            .filter { !isCorrect($0, map) }
            .map { $0.sorted(by: { (a, b) in map[a][b] < 0 }) }
            .map { $0[$0.count / 2] }
            .reduce(0, +)
        return "\(result)"
    }
}
