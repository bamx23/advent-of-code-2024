//
//  FileResultData.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import Foundation
import Shared

public struct FileResultData: ResultData {
    public let results: [ResultKey: String]
    
    public init(day: Int) {
        var results: [ResultKey: String] = [:]
        if let input = Self.readInput(day: day) {
            let lines = input.split(separator: "\n")
            var idx = 0
            while idx < lines.count {
                let line = lines[idx]
                let pair = line.split(separator: ":")
                let keyParts = pair[0].trimmingCharacters(in: .whitespaces).split(separator: "_")
                
                let part: TaskPart
                switch keyParts[0] {
                case "P1":
                    part = .part1
                case "P2":
                    part = .part2
                default:
                    fatalError()
                }
                
                let dataKind: DataKind
                switch keyParts[1].first {
                case "S":
                    dataKind = .sample(idx: Int(keyParts[1].dropFirst())! - 1)
                case "T":
                    dataKind = .task
                default:
                    fatalError()
                }
                
                var result = pair[1].trimmingCharacters(in: .whitespaces)
                if result == "\\" {
                    var multiline: [Substring] = []
                    idx += 1
                    while lines[idx].trimmingCharacters(in: .whitespaces) != "\\" {
                        multiline.append(lines[idx])
                        idx += 1
                    }
                    result = multiline.joined(separator: "\n")
                }
                results[.init(part: part, kind: dataKind)] = result
                idx += 1
            }
        }
        self.results = results
    }

    static private func readInput(day: Int) -> String? {
        guard let url = Bundle.module.url(forResource: String(format: "results%02d", day), withExtension: "txt", subdirectory: "files")
        else {
            return nil
        }
        return try? String(contentsOf: url)
    }
}
