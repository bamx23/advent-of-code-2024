//
//  Day23.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 23/12/2024.
//

import Foundation
import Shared

public struct Day23: Day {
    static public let number = 23

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    func parse() -> [String: Set<String>] {
        input
            .split(separator: "\n")
            .reduce(into: [:], { r, l in
                let p = l.split(separator: "-").map(String.init)
                r[p[0], default: []].insert(p[1])
                r[p[1], default: []].insert(p[0])
            })
    }
    
    public func part01() -> String {
        let links = parse()
        let result = Set(
            links
            .filter { $0.key.starts(with: "t") }
            .flatMap { (a, others) -> [Set<String>] in
                others.flatMap { b in
                    links[b]!.intersection(others)
                        .map { c in [a, b, c] }
                }
            }
        )
//        print(result.map{ $0.sorted().joined(separator: ",") }.sorted().joined(separator: "\n"))
        return "\(result.count)"
    }

    private func findMaxCliq(links: [String: Set<String>], cliq: Set<String>,
                             checked: inout Set<String>, maxCliq: inout Set<String>) {
        guard let next = cliq.subtracting(checked).first else {
            if cliq.count > maxCliq.count {
                maxCliq = cliq
            }
            return
        }
        checked.insert(next)
        findMaxCliq(links: links, cliq: cliq.subtracting([next]),
                    checked: &checked, maxCliq: &maxCliq)
        findMaxCliq(links: links, cliq: cliq.intersection(links[next]!.union([next])),
                    checked: &checked, maxCliq: &maxCliq)
        checked.remove(next)
    }

    public func part02() -> String {
        let links = parse()
        let result = links.parallelCompactMap { (a, others) in
            var maxCliq: Set<String> = []
            var checked: Set<String> = [a]
            findMaxCliq(links: links, cliq: others.union([a]), checked: &checked, maxCliq: &maxCliq)
            return maxCliq
        }
        .max(by: { $0.count < $1.count })!
        .sorted()
        .joined(separator: ",")
        return "\(result)"
    }
}
