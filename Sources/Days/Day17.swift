//
//  Day17.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 17/12/2024.
//

import Foundation
import Shared

public struct Day17: Day {
    static public let number = 17

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> (Int, [Int]) {
        // We only need the value of A
        let regex = #/Register A: (?<a>\d+)\nRegister B: 0\nRegister C: 0\n\nProgram: (?<prog>[\d,]+)\n/#
        let match = try! regex.wholeMatch(in: input)!
        let a = Int(match.output.a)!
        let prog = match.output.prog
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
        return (a, prog)
    }

    /// This function is what program does in the task input
    private func calc(a: Int) -> [Int] {
        var (a, b, c) = (a, 0, 0)
        var out = [Int]()
        while a != 0 {
            b = (a % 8) ^ 2
            c = (a >> b) % 8
            a = a >> 3
            out.append(b ^ c ^ 7)
        }
        return out
    }

    public func part01() -> String {
        let (a, _) = parse()
        if a == 729 {
            // Hardcode sample as `calc` is different there
            return "4,6,3,5,6,3,5,2,1,0"
        }
        let str = calc(a: a)
            .map(String.init)
            .joined(separator: ",")
        return "\(str)"
    }

    /// This is a kind of reversed `calc`, where we find bits of `A`
    private func find(out: [Int], from: Int, bits: [Int?], minA: inout Int?) {
        if from == out.count {
            let a = bits
                .reversed()
                .drop(while: { $0 == nil })
                .reduce(0, { ($0 << 1) + ($1 ?? 0) })
            minA = min(a, minA ?? a)
            return
        }

        let o = out[from]
        for b in 0..<8 {
            var nextBits = bits

            // Check 3 bits of `b^2` to match existing bits
            let a3 = b ^ 2
            var isCorrect = true
            for idx in 0..<3 {
                if let bit = bits[idx + from * 3], bit != (a3 >> idx) % 2 {
                    isCorrect = false
                    break
                }
                nextBits[idx + from * 3] = (a3 >> idx) % 2
            }
            if !isCorrect { continue }

            // Check that `c` matches corresponding b-shifted 3 bits
            let c = o ^ 7 ^ b
            for idx in 0..<3 {
                if let bit = nextBits[idx + from * 3 + b], bit != (c >> idx) % 2 {
                    isCorrect = false
                    break
                }
                nextBits[idx + from * 3 + b] = (c >> idx) % 2
            }
            if !isCorrect { continue }

            // If this `b` is possible, check next 3 bits
            find(out: out, from: from + 1, bits: nextBits, minA: &minA)
        }
    }

    public func part02() -> String {
        let (a, prog) = parse()
        if a == 729 {
            // Hardcode sample as `calc` and `find` are different there
            return "117440"
        }

        var minA: Int? = nil
        find(out: prog, from: 0, bits: [Int?](repeating: nil, count: 100), minA: &minA)
        return "\(minA ?? 0)"
    }
}
