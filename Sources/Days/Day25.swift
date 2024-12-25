//
//  Day25.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 25/12/2024.
//

import Foundation
import Shared
import Algorithms

public struct Day25: Day {
    static public let number = 25

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [(isKey: Bool, pins: [Int])] {
        input
            .split(separator: "\n\n")
            .map { block in
                let lines = block.split(separator: "\n")
                let isKey = lines.first?.first == "."
                let pins = lines.dropFirst().prefix(5)
                    .reduce(into: [Int](repeating: 0, count: 5), { pins, line in
                        for (idx, pin) in line.enumerated() {
                            if pin == "#" { pins[idx] += 1 }
                        }
                    })
                return (isKey, pins)
            }
    }
    
    public func part01() -> String {
        let data = parse()
        let result = product(
            data.filter({ $0.isKey }).map(\.pins),
            data.filter({ !$0.isKey }).map(\.pins)
        )
        .filter { (key, lock) -> Bool in
            zip(key, lock).allSatisfy { $0 + $1 <= 5 }
        }
        .count
        return "\(result)"
    }
    
    public func part02() -> String {
        return "Ho-ho-ho!"
    }
}
