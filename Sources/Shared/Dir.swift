//
//  Dir.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 17/12/2023.
//

import Foundation

public enum Dir: CaseIterable {
    case up
    case down
    case left
    case right
}

public extension Dir {
    var delta: Pos {
        switch self {
        case .up:       return .init(x: 0, y: -1)
        case .down:     return .init(x: 0, y: 1)
        case .left:     return .init(x: -1, y: 0)
        case .right:    return .init(x: 1, y: 0)
        }
    }

    var rev: Dir {
        switch self {
        case .left: return .right
        case .right: return .left
        case .up: return .down
        case .down: return .up
        }
    }

    var rotatedRight: Dir {
        switch self {
        case .left: return .up
        case .right: return .down
        case .up: return .right
        case .down: return .left
        }
    }

    var rotationDirs: [Dir] {
        switch self {
        case .up, .down: return [.left, .right]
        case .left, .right: return [.up, .down]
        }
    }

    var isHorizontal: Bool {
        switch self {
        case .left, .right: return true
        default: return false
        }
    }

    var isVertical: Bool {
        switch self {
        case .up, .down: return true
        default: return false
        }
    }
}
