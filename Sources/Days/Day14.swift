//
//  Day14.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 14/12/2024.
//

import Foundation
import Shared

public struct Day14: Day {
    static public let number = 14

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    struct Robot {
        var pos: Pos
        var vel: Pos
    }

    func parse() -> [Robot] {
        let r = #/p=(?<x>-?\d+),(?<y>-?\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/#
        return input.matches(of: r)
            .map { m in .init(
                pos: .init(x: Int(m.output.x)!, y: Int(m.output.y)!),
                vel: .init(x: Int(m.output.vx)!, y: Int(m.output.vy)!)
            ) }
    }
    
    public func part01() -> String {
        var robots = parse()
        let mapSize: Pos = robots.count > 20 ? .init(x: 101, y: 103) : .init(x: 11, y: 7)
        for idx in robots.indices {
            var robot = robots[idx]
            for _ in 0..<100 {
                robot.move(mapSize: mapSize)
            }
            robots[idx] = robot
        }

        let qSize = mapSize / 2
        let result = robots
            .filter { r in r.pos.x != qSize.x && r.pos.y != qSize.y }
            .map { r in Pos(x: r.pos.x < qSize.x ? 0 : 1, y: r.pos.y < qSize.y ? 0 : 1) }
            .grouped(by: { $0 })
            .map(\.value)
            .map(\.count)
            .reduce(1, *)
        return "\(result)"
    }
    
    public func part02() -> String {
        var robots = parse()

        let mapSize: Pos = robots.count > 20 ? .init(x: 101, y: 103) : .init(x: 11, y: 7)
        var sec = 0
        while Set(robots.map(\.pos)).count != robots.count {
            // Yes, the assumpption is that a tree is only visible when there's no overlaps
            for idx in robots.indices {
                robots[idx].move(mapSize: mapSize)
            }
            sec += 1
        }

//        let str = (0..<mapSize.y)
//            .map { y in
//                (0..<mapSize.x)
//                    .map { x in
//                        let pos = Pos(x: x, y: y)
//                        let count = robots.count { $0.pos == pos }
//                        return count == 0 ? "." : "\(count)"
//                    }
//                    .joined()
//            }
//            .joined(by: "\n")
//        print("\(sec)\n\(String(str))\n")

        return "\(sec)"
    }
}

private extension Day14.Robot {
    mutating func move(mapSize: Pos) {
        pos += vel
        while pos.x < 0 { pos.x += mapSize.x }
        while pos.y < 0 { pos.y += mapSize.y }
        while pos.x >= mapSize.x { pos.x -= mapSize.x }
        while pos.y >= mapSize.y { pos.y -= mapSize.y }
    }
}
