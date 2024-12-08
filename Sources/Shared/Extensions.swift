//
//  Extensions.swift
//  advent-of-code-2024
//
//  Created by Nikolay Volosatov on 08/12/2024.
//

import Foundation
import os

public extension Collection {
    func parallelCompactMap<T>(maxThreads: Int = 8, _ proc: @escaping (Element) -> Optional<T>) -> [T] {
        var lock = OSAllocatedUnfairLock()
        var nextIdx = self.startIndex
        var nextRIdx = 0
        var result: [Optional<T>] = .init(repeating: nil, count: count)

        let queue = DispatchQueue(label: "parallelCompactMap", qos: .userInitiated, attributes: [.concurrent])
        let group = DispatchGroup()
        for _ in 0..<Swift.min(maxThreads, count) {
            group.enter()
            queue.async {
                while true {
                    let (idx, rIdx) = lock.withLock {
                        if nextIdx == self.endIndex {
                            return (self.endIndex, 0)
                        }
                        let idx = nextIdx
                        let rIdx = nextRIdx
                        nextIdx = self.index(after: nextIdx)
                        nextRIdx += 1
                        return (idx, rIdx)
                    }
                    if idx == self.endIndex {
                        group.leave()
                        return
                    }
                    let val = proc(self[idx])
                    lock.withLock {
                        result[rIdx] = val
                    }
                }
            }
        }
        group.wait()
        return result.compactMap { $0 }
    }
}
