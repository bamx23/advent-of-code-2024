//
//  ResultData.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import Foundation

public enum TaskPart: Hashable {
    case part1
    case part2
}

public enum DataKind: Hashable {
    case sample(idx: Int)
    case task
}

public struct ResultKey: Hashable {
    var part: TaskPart
    var kind: DataKind
    
    public init(part: TaskPart, kind: DataKind) {
        self.part = part
        self.kind = kind
    }
}

public protocol ResultData {
    var results: [ResultKey: String] { get }
}
