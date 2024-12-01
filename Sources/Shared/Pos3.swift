//
//  File.swift
//  
//
//  Created by Nikolay Volosatov on 18/12/2022.
//

import Foundation

public typealias Pos3 = Pos3_G<Int>
public typealias Pos3f = Pos3_G<Double>

public struct Pos3_G<Value: Hashable & Numeric>: Hashable {
    public let x: Value
    public let y: Value
    public let z: Value

    public init(x: Value, y: Value, z: Value) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public func +<T>(lhs: Pos3_G<T>, rhs: Pos3_G<T>) -> Pos3_G<T> {
    .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

public func -<T>(lhs: Pos3_G<T>, rhs: Pos3_G<T>) -> Pos3_G<T> {
    .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

public func *<T>(lhs: Pos3_G<T>, rhs: T) -> Pos3_G<T> {
    .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}

public func *<T>(lhs: T, rhs: Pos3_G<T>) -> Pos3_G<T> {
    rhs * lhs
}

public func /(lhs: Pos3_G<Double>, rhs: Double) -> Pos3_G<Double> {
    lhs * (1 / rhs)
}

public extension Pos3_G {
    func dot(_ other: Self) -> Value { x * other.x + y * other.y + z * other.z }
    func cross(_ other: Self) -> Self {
        Self.init(x: y * other.z - other.y * z,
                  y: z * other.x - other.z * x,
                  z: x * other.y - other.x * y)
    }
    func norm2() -> Value { x * x + y * y + z * z }
    func norm() -> Double where Value == Double { sqrt(norm2()) }
}
