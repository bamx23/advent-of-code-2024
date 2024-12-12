//
//  Day12.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 12/12/2024.
//

import Foundation
import Shared

public struct Day12: Day {
    static public let number = 12

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Character]] {
        input
            .split(separator: "\n")
            .map(Array.init)
    }
    
    public func part01() -> String {
        let map = parse()
        var result = 0
        var visited: Set<Pos> = []
        map.iterPoses { posStart, chStart in
            guard !visited.contains(posStart) else { return }
            var stack: [Pos] = [posStart]
            visited.insert(posStart)
            var area = 1
            var perimeter = 0
            while let pos = stack.popLast() {
                var nextVisited = 0
                map.iterPoses(around: pos, allowDiagonal: false) { posNext, chNext in
                    nextVisited += 1
                    guard chNext == chStart else {
                        perimeter += 1
                        return
                    }
                    guard !visited.contains(posNext) else { return }
                    visited.insert(posNext)
                    stack.append(posNext)
                    area += 1
                }
                perimeter += (4 - nextVisited) // add out-of-map borders
            }
            result += area * perimeter
        }
        return "\(result)"
    }
    
    public func part02() -> String {
        let map = parse()
        var result = 0
        var visited: Set<Pos> = []
        map.iterPoses { posStart, chStart in
            guard !visited.contains(posStart) else { return }
            var stack: [Pos] = [posStart]
            visited.insert(posStart)
            var plants: Set<Pos> = [posStart]

            while let pos = stack.popLast() {
                map.iterPoses(around: pos, allowDiagonal: false) { posNext, chNext in
                    guard chNext == chStart else { return }
                    guard !visited.contains(posNext) else { return }
                    visited.insert(posNext)
                    plants.insert(posNext)
                    stack.append(posNext)
                }
            }

            var visBorders: Set<Border> = []
            var sides = 0
            for pos in plants {
                for side in Dir.allCases {
                    guard map[pos + side.delta] != chStart else { continue }
                    let border = Border(pos: pos, side: side)
                    guard !visBorders.contains(border) else { continue }
                    visBorders.insert(border)
                    sides += 1

                    for dir in side.rotationDirs {
                        var nextPos = pos + dir.delta
                        while map[nextPos] == chStart && map[nextPos + side.delta] != chStart {
                            let nextBorder = Border(pos: nextPos, side: side)
                            visBorders.insert(nextBorder)
                            nextPos = nextPos + dir.delta
                        }
                    }
                }
            }

            result += plants.count * sides
        }
        return "\(result)"
    }
}

private struct Border: Hashable {
    let pos: Pos
    let side: Dir
}
