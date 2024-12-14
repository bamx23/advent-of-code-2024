//
//  Pos.swift
//  
//
//  Created by Nikolay Volosatov on 15/12/2022.
//

import Foundation

public struct Pos: Hashable, CustomStringConvertible {
    public var x: Int
    public var y: Int

    public var description: String { "(\(x),\(y))" }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public static func x(_ val: Int) -> Self { .init(x: val, y: 0) }
    public static func y(_ val: Int) -> Self { .init(x: 0, y: val) }
}

public func +(lhs: Pos, rhs: Pos) -> Pos {
    .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func +=(lhs: inout Pos, rhs: Pos) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

public func -(lhs: Pos, rhs: Pos) -> Pos {
    .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func *(lhs: Pos, rhs: Int) -> Pos {
    .init(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func /(lhs: Pos, rhs: Int) -> Pos {
    .init(x: lhs.x / rhs, y: lhs.y / rhs)
}

public extension Pos {
    func manhDist(_ other: Pos) -> Int {
        return abs(other.x - x) + abs(other.y - y)
    }

    func wrap(w: Int, h: Int) -> Pos {
        let x = x < 0
        ? (w - ((-x) % w)) % w
        : (x % w)
        let y = y < 0
        ? (h - ((-y) % h)) % h
        : (y % h)
        return .init(x: x, y: y)
    }
}

public extension Array {
    subscript<T>(_ pos: Pos) -> Optional<T> where Element == Array<T> {
        get {
            guard 0 <= pos.y && pos.y < count else { return nil }
            let row = self[pos.y]
            guard 0 <= pos.x && pos.x < row.count else { return nil }
            return row[pos.x]
        }
        set {
            guard let newValue else { return }
            guard 0 <= pos.y && pos.y < count else { return }
            let row = self[pos.y]
            guard 0 <= pos.x && pos.x < row.count else { return }
            self[pos.y][pos.x] = newValue
        }
    }

    func pos<T>(of val: T) -> Optional<Pos> where Element == Array<T>, T: Equatable {
        for (y, row) in enumerated() {
            for (x, el) in row.enumerated() {
                if el == val {
                    return .init(x: x, y: y)
                }
            }
        }
        return nil
    }

    func iterPoses<T>(_ proc: (Pos, T) -> Void) where Element == Array<T> {
        for (y, row) in enumerated() {
            for (x, el) in row.enumerated() {
                proc(.init(x: x, y: y), el)
            }
        }
    }

    func iterPoses<T>(around center: Pos, allowDiagonal: Bool, proc: (Pos, T) -> Void) where Element == Array<T> {
        let deltas: [Pos] = Dir.allCases.map(\.delta)
        + (allowDiagonal ? [.init(x: -1, y: -1), .init(x: 1, y: 1), .init(x: -1, y: 1), .init(x: 1, y: -1)] : [])
        for delta in deltas {
            let pos = center + delta
            guard let val = self[pos] else { continue }
            proc(pos, val)
        }
    }
}
