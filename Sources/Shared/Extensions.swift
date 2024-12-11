//
//  Extensions.swift
//  advent-of-code-2024
//
//  Created by Nikolay Volosatov on 08/12/2024.
//

import Foundation
import os

private struct ParallelState<IndexType, ValueType> {
    var nextIdx: IndexType
    var nextRIdx: Int
    var result: [Optional<ValueType>]
}

public extension Collection {
    func parallelCompactMap<T>(maxThreads: Int = 8, _ proc: @escaping (Element) -> Optional<T>) -> [T] {
        let stateLock = OSAllocatedUnfairLock(initialState: ParallelState<Self.Index, T>(
            nextIdx: self.startIndex,
            nextRIdx: 0,
            result: .init(repeating: nil, count: count)
        ))

        let queue = DispatchQueue(label: "parallelCompactMap", qos: .userInitiated, attributes: [.concurrent])
        let group = DispatchGroup()
        for _ in 0..<Swift.min(maxThreads, count) {
            group.enter()
            queue.async {
                while true {
                    let (idx, rIdx) = stateLock.withLock { state in
                        if state.nextIdx == self.endIndex {
                            return (self.endIndex, 0)
                        }
                        let idx = state.nextIdx
                        let rIdx = state.nextRIdx
                        state.nextIdx = self.index(after: state.nextIdx)
                        state.nextRIdx += 1
                        return (idx, rIdx)
                    }
                    if idx == self.endIndex {
                        group.leave()
                        return
                    }
                    let val = proc(self[idx])
                    stateLock.withLock {
                        $0.result[rIdx] = val
                    }
                }
            }
        }
        group.wait()
        return stateLock
            .withLock { $0.result }
            .compactMap { $0 }
    }
}
