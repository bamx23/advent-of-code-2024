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

    public func part02() -> String {
        let (_, gates) = parse()

        if gates.count < 50 {
            // This solution doesn't work for sample
            return "-"
        }

        var idx = 1
        var caryVal = gates.first(where: { $0.op == .and && $0.hasInputs("x00", "y00") })!.result

        var swaps: [String] = []
        while caryVal.hasPrefix("z") == false {
            let (xVal, yVal, zVal) = (String(format: "x%02d", idx), String(format: "y%02d", idx), String(format: "z%02d", idx))

            var v1 = gates.first(where: { $0.op == .xor && $0.hasInputs(xVal, yVal) })!
            var c1 = gates.first(where: { $0.op == .and && $0.hasInputs(xVal, yVal) })!
            var zGate = gates.first(where: { $0.op == .xor && $0.hasInput(caryVal) })!
            var c2 = gates.first(where: { $0.op == .and && $0.hasInput(caryVal) })!

            let v1Val = Set([zGate.lhs, zGate.rhs]).subtracting([caryVal]).first!
            let cVals = Set([v1.result, c1.result, zGate.result, c2.result]).subtracting([zVal, v1Val])
            var cGate = gates.first(where: { $0.op == .or && cVals.contains($0.lhs) && cVals.contains($0.rhs) })!

            let swap = { (a: String, b: String) in
                if v1.result == a { v1.result = b }
                if c1.result == a { c1.result = b }
                if zGate.result == a { zGate.result = b }
                if c2.result == a { c2.result = b }
                if cGate.result == a { cGate.result = b }
            }

            if v1.result != v1Val {
                swaps.append(contentsOf: [v1.result, v1Val])
                swap(v1Val, v1.result)
                v1.result = v1Val
            } else if zGate.result != zVal {
                swaps.append(contentsOf: [zGate.result, zVal])
                swap(zVal, zGate.result)
                zGate.result = zVal
            } else if c1.result != cGate.lhs && c1.result != cGate.rhs {
                let c1Val = cGate.otherOnput(c2.result)
                swaps.append(contentsOf: [c1.result, c1Val])
                swap(c1Val, c1.result)
                c1.result = c1Val
            } else if c2.result != cGate.lhs && c2.result != cGate.rhs {
                let c2Val = cGate.otherOnput(c1.result)
                swaps.append(contentsOf: [c2.result, c2Val])
                swap(c2Val, c2.result)
                c2.result = c2Val
            }

            caryVal = cGate.result
            idx += 1
        }

        let result = swaps.sorted().joined(separator: ",")
        return "\(result)"
    }
}

private extension Day24.Gate {
    func hasInput(_ a: String) -> Bool {
        lhs == a || rhs == a
    }

    func hasInputs(_ a: String, _ b: String) -> Bool {
        (lhs == a && rhs == b)
        || (lhs == b && rhs == a)
    }

    func otherOnput(_ a: String) -> String {
        if lhs == a { return rhs }
        return lhs
    }

    mutating func swapResult(_ val: String) -> String {
        let x = result
        result = val
        return x
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
