//
//  ParallelBinarySearch.swift
//  advent-of-code-2024
//
//  Created by Nikolay Volosatov on 18/12/2024.
//

import Foundation
import os
import Atomics

public class ParallelBinarySearchToken {
    private var isCanceledInternal: ManagedAtomic<Bool> = .init(false)

    public var isCanceled: Bool {
        isCanceledInternal.load(ordering: .relaxed)
    }
    func cancel() {
        isCanceledInternal.store(true, ordering: .relaxed)
    }
}

private struct ParallelBSState {
    var lIdx: Int
    var rIdx: Int
    var visited: Set<Int>
    var pending: [Int: ParallelBinarySearchToken]
    var results: [Int: ComparisonResult]

    mutating func next() -> (Int, ParallelBinarySearchToken)? {
        var queue: [(Int, Int)] = [(lIdx, rIdx)]
        while !queue.isEmpty {
            let (l, r) = queue.removeFirst()
            guard l < r else { return nil }
            let mid = l + (r - l) / 2
            guard visited.contains(mid) else {
                let token = ParallelBinarySearchToken()
                pending[mid] = token
                visited.insert(mid)
                return (mid, token)
            }
            queue.append(contentsOf: [(l, mid), (mid + 1, r)])
        }
        return nil
    }

    mutating func complete(mid: Int, val: ComparisonResult, token: ParallelBinarySearchToken) {
        pending[mid] = nil
        if token.isCanceled { return }

        results[mid] = val
        guard mid == lIdx + (rIdx - lIdx) / 2 else {
            // Only process the current root of BS
            return
        }

        var mid = mid
        while let nextVal = results[mid] {
            if nextVal == .orderedAscending {
                lIdx = mid + 1
            } else {
                rIdx = mid
            }
            guard lIdx < rIdx else { return }
            mid = lIdx + (rIdx - lIdx) / 2
        }

        // Cancel all pending jobs that are outside of current range
        pending = Dictionary(uniqueKeysWithValues: pending.filter({ (idx, tok) in
            if idx < lIdx || idx >= rIdx {
                tok.cancel()
                return false
            }
            return true
        }))
    }
}

public extension Array {
    func parallelBinarySearch(maxThreads: Int = 8, _ proc: @escaping (Element, ParallelBinarySearchToken) -> ComparisonResult) -> Index? {
        let stateLock = OSAllocatedUnfairLock(initialState: ParallelBSState(
            lIdx: 0,
            rIdx: count - 1,
            visited: [],
            pending: [:],
            results: [:]
        ))

        let queue = DispatchQueue(label: "parallelBinarySearch", qos: .userInitiated, attributes: [.concurrent])
        let group = DispatchGroup()
        for _ in 0..<Swift.min(maxThreads, count) {
            group.enter()
            queue.async {
                while let (mid, token) = stateLock.withLock({ $0.next() }) {
                    let val = proc(self[mid], token)
                    stateLock.withLock { $0.complete(mid: mid, val: val, token: token) }
                }
                group.leave()
            }
        }
        group.wait()
        return stateLock.withLock {
            $0.lIdx == $0.rIdx ? $0.lIdx : nil
        }
    }
}
