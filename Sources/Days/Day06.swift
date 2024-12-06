//
//  Day06.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 06/12/2024.
//

import Foundation
import Shared

public struct Day06: Day {
    static public let number = 6

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Cell: Character {
        case empty = "."
        case wall = "#"
        case `guard` = "^"
    }

    func parse() -> [[Cell]] {
        input
            .split(separator: "\n")
            .map { l in l.compactMap(Cell.init) }
    }

    private func allVisitedPositions(_ map: [[Cell]], pos: Pos, dir: Dir) -> [Pos: Dir] {
        var pos = pos
        var dir = dir
        var visited: [Pos: Dir] = [pos: dir]

        var exited = false
        while !exited {
            let nextPos = pos + dir.delta
            switch map[nextPos] {
            case .empty:
                pos = nextPos
                if visited[pos] == nil {
                    visited[pos] = dir
                }
            case .wall:
                dir = dir.rotatedRight
            case nil:
                exited = true
            case .guard:
                assertionFailure()
            }
        }
        return visited
    }

    private func checkLoop(_ map: [[Cell]], pos: Pos, dir: Dir) -> Bool {
        struct Key: Hashable {
            let pos: Pos
            let dir: Dir
        }
        var pos = pos
        var dir = dir
        var visitedWall: Set<Key> = []

        while true {
            let nextPos = pos + dir.delta
            switch map[nextPos] {
            case .empty:
                pos = nextPos
            case .wall:
                let key = Key(pos: pos, dir: dir)
                if visitedWall.contains(key) {
                    return true
                }
                visitedWall.insert(key)
                dir = dir.rotatedRight
            case nil:
                return false
            case .guard:
                assertionFailure()
            }
        }
    }

    public func part01() -> String {
        var map = parse()
        let pos = map.pos(of: .guard)!
        map[pos] = .empty

        let visited = allVisitedPositions(map, pos: pos, dir: .up)
        return "\(visited.count)"
    }
    
    public func part02() -> String {
        var map = parse()
        let pos = map.pos(of: .guard)!
        map[pos] = .empty

        let result = allVisitedPositions(map, pos: pos, dir: .up)
            .filter { $0.key != pos }
            .filter { (p, d) in
                map[p] = .wall
                let hasLoop = checkLoop(map, pos: p + d.rev.delta, dir: d.rotatedRight)
                map[p] = .empty
                return hasLoop
            }
        return "\(result.count)"
    }
}
