//
//  TaskData.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

public protocol TaskData {
    var samples: [String] { get }
    var task: String? { get }
}
