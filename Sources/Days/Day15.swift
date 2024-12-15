//
//  Day15.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 15/12/2024.
//

import Foundation
import Shared

public struct Day15: Day {
    static public let number = 15

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Cell: Character {
        case empty = "."
        case wall = "#"
        case box = "O"
        case robot = "@"
        case boxL = "["
        case boxR = "]"
    }

    func parse() -> ([[Cell]], [Dir]) {
        let blocks = input.split(separator: "\n\n")
        let map = blocks[0]
            .split(separator: "\n")
            .map { l in l.compactMap(Cell.init) }
        let moves = blocks[1]
            .compactMap(Dir.parse)
        return (map, moves)
    }
    
    public func part01() -> String {
        let (mapIm, moves) = parse()
        var map = mapIm
        var robot = map.pos(of: .robot)!

        for move in moves {
            let pos = robot + move.delta
            switch map[pos] {
            case .empty:
                map[robot] = .empty
                map[pos] = .robot
                robot = pos
            case .box:
                var afterPos = pos + move.delta
                while map[afterPos] == .box { afterPos += move.delta }
                if map[afterPos] == .empty {
                    map[robot] = .empty
                    map[pos] = .robot
                    robot = pos
                    map[afterPos] = .box
                }
            default: break
            }
        }

//        if map.count < 30 {
//            let str = map
//                .map { r in String(r.map(\.rawValue)) }
//                .joined(separator: "\n")
//            print(str)
//        }

        let result = map
            .mapPoses { (pos, ch) -> Int? in
                guard ch == .box else { return nil }
                return pos.x + pos.y * 100
            }
            .reduce(0, +)
        return "\(result)"
    }
    
    public func part02() -> String {
        let (mapIm, moves) = parse()
        var map = mapIm.map { r in
            r.flatMap { ch -> [Cell] in
                switch ch {
                case .box: return [.boxL, .boxR]
                case .robot: return [.robot, .empty]
                default: return [ch, ch]
                }
            }
        }
        var robot = map.pos(of: .robot)!

        for move in moves {
            let pos = robot + move.delta
            switch map[pos] {
            case .empty:
                map[robot] = .empty
                map[pos] = .robot
                robot = pos

            case .boxL, .boxR:
                if move.isHorizontal {
                    var afterPos = pos + move.delta
                    while map[afterPos].isAnyBox { afterPos += move.delta }
                    if map[afterPos] == .empty {
                        while afterPos != robot {
                            map[afterPos] = map[afterPos - move.delta]
                            afterPos -= move.delta
                        }
                        map[robot] = .empty
                        robot = pos
                    }
                } else {
                    var frontL = map[pos] == .boxL ? [pos] : [pos - .x(1)]
                    var layers = [frontL]
                    var canMove = true
                    while canMove {
                        var nextFront = Set<Pos>()
                        for boxPos in frontL {
                            let nextPoses = [boxPos + move.delta, boxPos + .x(1) + move.delta]
                            if nextPoses.allSatisfy({ map[$0] == .empty }) {
                                continue // This box can be fully moved
                            }
                            if nextPoses.contains(where: { map[$0] == .wall }) {
                                canMove = false
                                break // Stop this move, it can't be done
                            }
                            for nextPos in nextPoses {
                                switch map[nextPos] {
                                case .boxL: nextFront.insert(nextPos)
                                case .boxR: nextFront.insert(nextPos - .x(1))
                                case .empty: break
                                default: assertionFailure("Unexpected cell \(map[nextPos]?.rawValue ?? "?")")
                                }
                            }
                        }
                        if nextFront.isEmpty {
                            break
                        }
                        frontL = Array(nextFront)
                        layers.append(frontL)
                    }
                    if canMove {
                        for layer in layers.reversed() {
                            for boxPos in layer {
                                map[boxPos + move.delta] = .boxL
                                map[boxPos + move.delta + .x(1)] = .boxR
                                map[boxPos] = .empty
                                map[boxPos + .x(1)] = .empty
                            }
                        }
                        map[pos] = .robot
                        map[robot] = .empty
                        robot = pos
                    }
                }
            default: break
            }
        }

//        if map.count < 30 {
//            let str = map
//                .map { r in String(r.map(\.rawValue)) }
//                .joined(separator: "\n")
//            print(str)
//        }

        let result = map
            .mapPoses { (pos, ch) -> Int? in
                guard ch == .boxL else { return nil }
                return pos.x + pos.y * 100
            }
            .reduce(0, +)
        return "\(result)"
    }
}

private extension Dir {
    static func parse(_ ch: Character) -> Dir? {
        switch ch {
        case "^": return .up
        case "v": return .down
        case "<": return .left
        case ">": return .right
        default: return nil
        }
    }
}

private extension Optional where Wrapped == Day15.Cell {
    var isAnyBox: Bool { self == .boxR || self == .boxL }
}
