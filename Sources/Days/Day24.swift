//
//  Day24.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 24/12/2024.
//

import Foundation
import Shared
import Algorithms

public struct Day24: Day {
    static public let number = 24

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Operation: String, Hashable {
        case and = "AND"
        case or = "OR"
        case xor = "XOR"
    }

    struct Gate: Hashable {
        var op: Operation
        var lhs: String
        var rhs: String
        var result: String
    }

    func parse() -> (wires: [String:Int], gates: [Gate]) {
        let pair = input.split(separator: "\n\n")
        let wires = Dictionary(
            uniqueKeysWithValues: pair[0]
            .split(separator: "\n")
            .map { l in
                let p = l.split(separator: ": ")
                let key = String(p[0])
                let value = Int(p[1])!
                return (key, value)
            }
        )
        let gates = pair[1]
            .split(separator: "\n")
            .map { l in
                let p = l.split(separator: " ")
                let lhs = String(p[0])
                let op = Operation(rawValue: String(p[1]))
                let rhs = String(p[2])
                let result = String(p[4])
                return Gate(op: op!, lhs: lhs, rhs: rhs, result: result)
            }
        return (wires, gates)
    }

    private func calc(wires: [String:Int], gates: [Gate]) -> [Int]? {
        var (wires, gates) = (wires, gates)
        let zWires = Set(gates.map(\.result).filter { $0.starts(with: "z") })
        while Set(wires.keys).isSuperset(of: zWires) == false {
            var didAnything = false
            gates = gates.filter { gate in
                guard let lhsValue = wires[gate.lhs], let rhsValue = wires[gate.rhs] else { return true }
                wires[gate.result] = gate.op.calc(lhs: lhsValue, rhs: rhsValue)
                didAnything = true
                return false
            }
            if !didAnything { return nil }
        }
//        print(
//            wires
//                .sorted(by: {$0.key < $1.key})
//                .map { "\($0.key): \($0.value)" }
//                .joined(separator: "\n")
//        )
        let result = zWires
            .sorted()
            .map { wires[$0]! }
        return result
    }

    public func part01() -> String {
        let (wires, gates) = parse()
        let result = calc(wires: wires, gates: gates)!
            .reversed()
            .reduce(0, { $0 * 2 + $1 })
        return "\(result)"
    }

    private func genInput(bitsCount: Int, randGen: inout RandomNumberGenerator) -> ([String: Int], [Int]) {
        var (x, y) = (
            (0..<(1 << bitsCount)).randomElement(using: &randGen)!,
            (0..<(1 << bitsCount)).randomElement(using: &randGen)!
        )
        var z = x + y
        var wires: [String: Int] = [:]
        var result: [Int] = []
        for idx in 0..<bitsCount {
            wires[String(format: "x%02d", idx)] = x & 1
            wires[String(format: "y%02d", idx)] = y & 1
            result.append(z & 1)
            x >>= 1
            y >>= 1
            z >>= 1
        }
        result.append(z & 1)
        return (wires, result)
    }

    public func part02() -> String {
        let (wiresInit, gates) = parse()
        let bitsCount = wiresInit.count / 2
        var randGen: any RandomNumberGenerator = SplitMix64RandomNumberGenerator(seed: 23)

        let calcSamples = (0..<1000).map { _ in genInput(bitsCount: bitsCount, randGen: &randGen) }
        let bestScore = calcSamples.count * (bitsCount + 1)
        var bestSwap: [Int]
        var population = (0..<100).map { _ in
            var indices = [Int]()
            while indices.count != 8 {
                var next = (0..<gates.count).randomElement(using: &randGen)!
                while indices.contains(next) {
                    next = (0..<gates.count).randomElement(using: &randGen)!
                }
                indices.append(next)
            }
            return indices
        }
        var popIdx = 0
        while true {
            let scored = population
                .parallelCompactMap { indices in
                    var gates = gates
                    for idx in 0..<4 {
                        let (a, b) = (indices[idx * 2], indices[idx * 2 + 1])
                        (gates[a].result, gates[b].result) = (gates[b].result, gates[a].result)
                    }

                    var score = 0
                    for (wires, expectedResult) in calcSamples {
                        guard let curResult = calc(wires: wires, gates: gates) else {
                            score = 0
                            break
                        }
                        score += zip(curResult, expectedResult).count(where: { $0 == $1 })
                    }
                    return (val: indices, score: score)
                }
                .sorted(by: { $0.score > $1.score })
            if let best = scored.first {
                if best.score == bestScore {
                    bestSwap = best.val
                    break
                }
                if popIdx % 10 == 0 {
                    print("\(popIdx) best score: \(best.score)")
                }
            }
            let top = scored
                .prefix(20)
                .map(\.val)
            let mutated = top.map { indices in
                var indices = indices
                for j in 0..<indices.count {
                    if (0..<99).randomElement(using: &randGen)! < 20 {
                        var other = indices[j]
                        while indices.contains(other) {
                            other = (0..<gates.count).randomElement(using: &randGen)!
                        }
                        indices[j] = other
                    }
                }
                return indices
            }
            let merged = zip(
                top.shuffled(using: &randGen),
                top.shuffled(using: &randGen)
            ).map { (lhsIds, rhsIds) in
                zip(lhsIds, rhsIds).map { (lhs, rhs) in
                    Bool.random(using: &randGen) ? lhs : rhs
                }
            }
            population = top + mutated + merged
            popIdx += 1
        }

        let result = bestSwap
            .map { gates[$0].result }
            .sorted()
            .joined(separator: ",")
        return "\(result)"
    }
}

private extension Day24.Operation {
    func calc(lhs: Int, rhs: Int) -> Int {
        switch self {
        case .and: return lhs & rhs
        case .or: return lhs | rhs
        case .xor: return lhs ^ rhs
        }
    }
}
