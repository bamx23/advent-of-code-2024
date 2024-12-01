//
//  Day.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

public protocol Day {
    static var number: Int { get }
    
    init(input: String)
    
    func part01() -> String
    func part02() -> String
}
