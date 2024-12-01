//
//  Runner.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

public func runDay<D: Day, T: TaskData>(dayType: D.Type, data: T) {
    func run(day: D, title: String) {
        let start = Date()
        print("== \(title): ==")
        print("Part 1:")
        print(day.part01())
        print("Part 2:")
        print(day.part02())
        print("Time: \(String(format: "%0.4f", -start.timeIntervalSinceNow))")
    }
    
    print("=== \(dayType): ===")
    
    for (idx, sample) in data.samples.enumerated() {
        let day = dayType.init(input: sample)
        run(day: day, title: "Sample \(idx + 1)")
    }
    
    if let task = data.task {
        let day = dayType.init(input: task)
        run(day: day, title: "Task")
    }
    
    print("")
}
