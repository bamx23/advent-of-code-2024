//
//  Day16.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 16/12/2024.
//

import Foundation
import Shared
import Collections

public struct Day16: Day {
    static public let number = 16

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Cell: Character {
        case empty = "."
        case wall = "#"
        case start = "S"
        case end = "E"
    }

    func parse() -> [[Cell]] {
        input
            .split(separator: "\n")
            .map { l in l.compactMap(Cell.init) }
    }

    struct State: Hashable, Comparable {
        var pos: Pos
        var dir: Dir
        var score: Int
        var path: [Pos]?

        static func < (lhs: Day16.State, rhs: Day16.State) -> Bool {
            lhs.score < rhs.score
        }
    }

    private func minScore(map: [[Cell]], start: Pos) -> Int {
        let startState = State(pos: start, dir: .right, score: 0)
        var visited = Set<Pos>()
        var heap = Heap([startState])
        while let cur = heap.popMin() {
            var pos = cur.pos
            var score = cur.score
            if visited.contains(pos) { continue }
            visited.insert(pos)

            while map[pos] == .empty {
                for dir in cur.dir.rotationDirs {
                    if map[pos + dir.delta] == .empty {
                        heap.insert(.init(pos: pos + dir.delta, dir: dir, score: score + 1001))
                    }
                }
                pos += cur.dir.delta
                score += 1
            }
            if map[pos] == .end {
                return score
            }
        }
        return 0
    }

    public func part01() -> String {
        var map = parse()
        let start = map.pos(of: .start)!
        map[start] = .empty
        return "\(minScore(map: map, start: start))"
    }
    
    public func part02() -> String {
        var map = parse()
        let start = map.pos(of: .start)!
        map[start] = .empty

        var minScore = minScore(map: map, start: start)
        var visited: [Pos: Int] = [:]
        var allMinTiles = Set<Pos>()

        let startState = State(pos: start, dir: .right, score: 0, path: [])
        var heap = Heap([startState])
        while let cur = heap.popMin() {
            var pos = cur.pos
            var score = cur.score
            var path = cur.path!

            if let visitedScore = visited[pos] {
                if score > visitedScore { continue }
            } else {
                visited[pos] = score
            }

            while map[pos] == .empty {
                path.append(pos)
                for dir in cur.dir.rotationDirs {
                    if map[pos + dir.delta] == .empty {
                        heap.insert(.init(pos: pos + dir.delta, dir: dir, score: score + 1001, path: path))
                    }
                }
                pos += cur.dir.delta
                score += 1
            }

            if map[pos] == .end {
                if minScore != score { break }
                path.append(pos)
                allMinTiles.formUnion(path)
                minScore = score
            }
        }
        return "\(allMinTiles.count)"
    }
}
