//
//  SplitMix64RandomNumberGenerator.swift
//  AdventOfCode2024
//
//  Created by Nikolay Volosatov on 24/12/2024.
//  Based on the SO answer from Heath Borders:
//  https://stackoverflow.com/a/76233303
//

/** This is a fixed-increment version of Java 8's SplittableRandom generator.
 It is a very fast generator passing BigCrush, with 64 bits of state.
 See http://dx.doi.org/10.1145/2714064.2660195 and
 http://docs.oracle.com/javase/8/docs/api/java/util/SplittableRandom.html

 Derived from public domain C implementation by Sebastiano Vigna
 See http://xoshiro.di.unimi.it/splitmix64.c
 */
public struct SplitMix64RandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z: UInt64 = state
        z = (z ^ (z &>> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z &>> 27)) &* 0x94d049bb133111eb
        return z ^ (z &>> 31)
    }
}
