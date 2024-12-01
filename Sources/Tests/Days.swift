//
//  Days.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import XCTest
import Days
import Input
import Shared

struct TestData {
    typealias DayResult = (part1: String, part2: String)
    
    let taskData: TaskData
    let resultData: ResultData
    
    init(day: Int) {
        taskData = FileTaskData(day: day)
        resultData = FileResultData(day: day)
    }
}

final class Days: XCTestCase {
    
    func testDay(_ dayNum: Int) throws {
        guard let dayType = allDays.first(where: { $0.number == dayNum }) else {
            throw XCTSkip("Not yet implemented")
        }
        let data = TestData(day: dayNum)

        func run(day: Day, kind: DataKind) {
            if let result = data.resultData.results[.init(part: .part1, kind: kind)] {
                XCTAssertEqual(day.part01(), result, "Day \(dayNum) has incorrect result for part 1 in \(kind)")
            }
            if let result = data.resultData.results[.init(part: .part2, kind: kind)] {
                XCTAssertEqual(day.part02(), result, "Day \(dayNum) has incorrect result for part 2 in \(kind)")
            }
        }

        for (idx, sample) in data.taskData.samples.enumerated() {
            let day = dayType.init(input: sample)
            run(day: day, kind: .sample(idx: idx))
        }
        
        if let task = data.taskData.task {
            let day = dayType.init(input: task)
            run(day: day, kind: .task)
        }
    }

    func testDay01() throws {
        try testDay(1)
    }
    
    func testDay02() throws {
        try testDay(2)
    }
    
    func testDay03() throws {
        try testDay(3)
    }
    
    func testDay04() throws {
        try testDay(4)
    }
    
    func testDay05() throws {
        try testDay(5)
    }
    
    func testDay06() throws {
        try testDay(6)
    }
    
    func testDay07() throws {
        try testDay(7)
    }
    
    func testDay08() throws {
        try testDay(8)
    }
    
    func testDay09() throws {
        try testDay(9)
    }
    
    func testDay10() throws {
        try testDay(10)
    }
    
    func testDay11() throws {
        try testDay(11)
    }
    
    func testDay12() throws {
        try testDay(12)
    }
    
    func testDay13() throws {
        try testDay(13)
    }
    
    func testDay14() throws {
        try testDay(14)
    }
    
    func testDay15() throws {
        try testDay(15)
    }
    
    func testDay16() throws {
        try testDay(16)
    }
    
    func testDay17() throws {
        try testDay(17)
    }
    
    func testDay18() throws {
        try testDay(18)
    }
    
    func testDay19() throws {
        try testDay(19)
    }
    
    func testDay20() throws {
        try testDay(20)
    }
    
    func testDay21() throws {
        try testDay(21)
    }
    
    func testDay22() throws {
        try testDay(22)
    }
    
    func testDay23() throws {
        try testDay(23)
    }

    func testDay24() throws {
        try testDay(24)
    }

    func testDay25() throws {
        try testDay(25)
    }

}
