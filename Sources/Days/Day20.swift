//
//  Day20.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 20/12/2024.
//

import Foundation
import Shared

public struct Day20: Day {
    static public let number = 20

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Cell: Character {
        case empty = "."
        case wall = "#"
        case start = "S"
        case end = "E"
        case cheat1 = "1"
        case cheat2 = "2"
        case visited = "*"
    }

    func parse() -> [[Cell]] {
        input
            .split(separator: "\n")
            .map { l in l.compactMap(Cell.init) }
    }

    private func dfsFill(_ map: [[Cell]], start: Pos) -> [[Int]] {
        var result: [[Int]] = map.map { l in l.map { _ in -1 } }
        result[start] = 0
        var queue: [(Int, Pos)] = [(0, start)]
        while !queue.isEmpty {
            let (steps, pos) = queue.removeFirst()
            map.iterPoses(around: pos, allowDiagonal: false) { nb, cell in
                guard result[nb] == -1 else { return }
                result[nb] = steps + 1
                if cell == .empty {
                    queue.append((steps + 1, nb))
                }
            }
        }
        return result
    }

    private func calc(map: [[Cell]], minCut: Int, maxCheat: Int = 2) -> Int {
        var map = map
        let start = map.pos(of: .start)!
        let end = map.pos(of: .end)!
        map[start] = .empty
        map[end] = .empty

        let sMap = dfsFill(map, start: start)
        let eMap = dfsFill(map, start: end)
        let routeLen = sMap[end]!

        let cuts = Array(map.enumerated()).parallelCompactMap { (y, line) -> [Int] in
            var cuts: [Int] = []
            for (x, cell) in line.enumerated() {
                let pos = Pos(x: x, y: y)
                guard cell == .empty && pos != end else { continue }
                guard let sLen = sMap[pos], sLen != -1 else { continue }

                var queue = [(maxCheat - 1, pos)]
                var visited: Set<Pos> = [pos]
                while !queue.isEmpty {
                    let (cheatLeft, cur) = queue.removeFirst()
                    map.iterPoses(around: cur, allowDiagonal: false) { nb, nCell in
                        guard visited.contains(nb) == false else { return }
                        visited.insert(nb)
                        if nCell == .empty, let eLen = eMap[nb], eLen != -1 {
                            let len = sLen + eLen + (maxCheat - 1 - cheatLeft) + 1
                            if len < routeLen {
                                cuts.append(routeLen - len)
                            }

    //                        if map.count < 50, routeLen - len == 76 {
    //                            print("cut: \(routeLen - len) (len: \(len), steps: \(21 - cheatLeft + 1), sLen: \(sLen), eLen: \(eLen))")
    //                            var m = map
    //                            for v in visited { if m[v] == .wall { m[v] = .visited } }
    //                            m[start] = .start
    //                            m[end] = .end
    //                            m[pos] = .cheat1
    //                            m[nb] = .cheat2
    //                            print(m.map{ l in String(l.map(\.rawValue)) }.joined(separator: "\n"))
    //                        }
                        }
                        if cheatLeft != 0 {
                            queue.append((cheatLeft - 1, nb))
                        }
                    }
                }
            }
            return cuts
        }.flatMap { $0 }

//        if map.count < 50 {
//            let cutsDebug = cuts
//                .grouped(by: { $0 })
//                .mapValues(\.count)
//                .sorted(by: { $0.key < $1.key })
//                .filter { $0.key >= minCut }
//            for (cut, count) in cutsDebug {
//                print("\(cut): \(count)")
//            }
//        }

        return cuts.count(where: { $0 >= minCut })
    }

    public func part01() -> String {
        let map = parse()
        let result = calc(map: map, minCut: map.count < 50 ? 2 : 100)
        return "\(result)"
    }
    
    public func part02() -> String {
        let map = parse()
        let result = calc(map: map, minCut: map.count < 50 ? 50 : 100, maxCheat: 20)
        return "\(result)"
    }
}
