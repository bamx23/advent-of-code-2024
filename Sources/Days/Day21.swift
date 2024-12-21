//
//  Day21.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 21/12/2024.
//

import Foundation
import Shared
import Algorithms

public struct Day21: Day {
    static public let number = 21

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    private func parse() -> [[NumCell]] {
        input
            .split(separator: "\n")
            .map { $0.compactMap(NumCell.init) }
    }

    private func solve(robotChain: Int) -> Int {
        let pairs = parse()
            .parallelCompactMap { input in
                var cache: [Key<DirCell>: Int] = [:]
                var minLen = 0
                var cur: NumCell = .activate
                for next in input {
                    minLen += NumCell.minPathLen(from: cur, to: next, chainLeft: robotChain + 1, cache: &cache)
                    cur = next
                }

                let num = Int(String(input.filter({ $0 != .activate }).map(\.rawValue)))!
                return (num, minLen)
            }
//        print(pairs.map { "\($0.1) * \($0.0)" }.joined(separator: "\n"))
        let result = pairs
            .map { $0.0 * $0.1 }
            .reduce(0, +)
        return result
    }

    public func part01() -> String {
        return "\(solve(robotChain: 2))"
    }

    public func part02() -> String {
        return "\(solve(robotChain: 25))"
    }
}

private protocol Cell: Equatable, Hashable {
    static var activate: Self { get }
    static var gap: Self { get }
    static var board: [[Self]] { get }
}

private enum NumCell: Character, Cell {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case gap = " "
    case activate = "A"

    static let board: [[Self]] =
    """
    789
    456
    123
     0A
    """.split(separator: "\n").map { $0.compactMap(NumCell.init) }
}

private enum DirCell: Character, Cell {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
    case gap = " "
    case activate = "A"

    static let board: [[Self]] = [
        [.gap, .up, .activate],
        [.left, .down, .right],
    ]
}

private struct Key<T>: Hashable where T: Cell {
    var start: T
    var target: T
    let chainLeft: Int
}

private func singleDirLen(dir: DirCell, count: Int, chainLeft: Int, cache: inout [Key<DirCell>: Int]) -> Int {
    DirCell.minPathLen(from: .activate, to: dir, chainLeft: chainLeft - 1, cache: &cache)
    + (count - 1)
    + DirCell.minPathLen(from: dir, to: .activate, chainLeft: chainLeft - 1, cache: &cache)
}

private func doubleDirLen(dirA: DirCell, countA: Int, dirB: DirCell, countB: Int, chainLeft: Int, cache: inout [Key<DirCell>: Int]) -> Int {
    DirCell.minPathLen(from: .activate, to: dirA, chainLeft: chainLeft - 1, cache: &cache)
    + (countA - 1)
    + DirCell.minPathLen(from: dirA, to: dirB, chainLeft: chainLeft - 1, cache: &cache)
    + (countB - 1)
    + DirCell.minPathLen(from: dirB, to: .activate, chainLeft: chainLeft - 1, cache: &cache)
}

extension Cell {
    static var activatePos: Pos { board.pos(of: .activate)! }

    static func minPathLen(from start: Self, to target: Self, chainLeft: Int, cache: inout [Key<DirCell>: Int]) -> Int {
        if start == target { return 1 /* Just "A" */ }
        if chainLeft == 0 {
            return 1 /* Just press it */
        }

        let key = Key(start: start, target: target, chainLeft: chainLeft)
        if let k = key as? Key<DirCell>, let cached = cache[k] { return cached }

        let board = Self.board
        let gap = Self.gap
        let sPos = board.pos(of: start)!
        let tPos = board.pos(of: target)!

        let delta = tPos - sPos
        let (hDir, hLen): (DirCell, Int) = delta.x > 0 ? (.right, delta.x) : (.left, -delta.x)
        let (vDir, vLen): (DirCell, Int) = delta.y > 0 ? (.down, delta.y) : (.up, -delta.y)

        let result: Int
        if delta.x == 0 {
            // Just vertical (single path)
            result = singleDirLen(dir: vDir, count: vLen, chainLeft: chainLeft, cache: &cache)
        } else if delta.y == 0 {
            // Just horizontal (single path)
            result = singleDirLen(dir: hDir, count: hLen, chainLeft: chainLeft, cache: &cache)
        } else {
            if board[sPos + .y(delta.y)] == gap {
                // Need to go horizntal first (otherwise there's a gap)
                result = doubleDirLen(dirA: hDir, countA: hLen, dirB: vDir, countB: vLen, chainLeft: chainLeft, cache: &cache)
            } else if board[sPos + .x(delta.x)] == gap {
                // Need to go vertical first (otherwise there's a gap)
                result = doubleDirLen(dirA: vDir, countA: vLen, dirB: hDir, countB: hLen, chainLeft: chainLeft, cache: &cache)
            } else {
                // Both paths possible
                result = min(
                    doubleDirLen(dirA: hDir, countA: hLen, dirB: vDir, countB: vLen, chainLeft: chainLeft, cache: &cache),
                    doubleDirLen(dirA: vDir, countA: vLen, dirB: hDir, countB: hLen, chainLeft: chainLeft, cache: &cache)
                )
            }
        }
        if let k = key as? Key<DirCell> { cache[k] = result }
        return result
    }
}
