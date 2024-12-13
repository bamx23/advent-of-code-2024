//
//  Day13.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 13/12/2024.
//

import Foundation
import Shared

public struct Day13: Day {
    static public let number = 13

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    struct Setup {
        var a: Pos
        var b: Pos
        var prize: Pos
    }

    func parse() -> [Setup] {
        let regex = #/Button A: X\+(?<aX>\d+), Y\+(?<aY>\d+)\nButton B: X\+(?<bX>\d+), Y\+(?<bY>\d+)\nPrize: X=(?<pX>\d+), Y=(?<pY>\d+)\n*/#
        return input.matches(of: regex)
            .map { m in .init(
                a: .init(x: Int(m.output.aX)!, y: Int(m.output.aY)!),
                b: .init(x: Int(m.output.bX)!, y: Int(m.output.bY)!),
                prize: .init(x: Int(m.output.pX)!, y: Int(m.output.pY)!)
            )}
    }
    
    public func part01() -> String {
        let result = parse()
            .compactMap(\.tokens)
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let extra = 10_000_000_000_000
        let pExtra = Pos(x: extra, y: extra)
        let result = parse()
            .map { Setup(a: $0.a, b: $0.b, prize: $0.prize + pExtra) }
            .compactMap(\.tokens)
            .reduce(0, +)
        return "\(result)"
    }
}

extension Day13.Setup {
    var tokens: Int? {
        let denA = (a.y * b.x - a.x * b.y)
        if denA == 0 { assertionFailure() }
        let nomA = (prize.y * b.x - prize.x * b.y)
        guard nomA.isMultiple(of: denA) else { return nil }
        let cA = nomA / denA

        let nomB = (prize.x - cA * a.x)
        guard nomB.isMultiple(of: b.x) else { return nil }
        let cB = nomB / b.x

        return cA * 3 + cB
    }
}
