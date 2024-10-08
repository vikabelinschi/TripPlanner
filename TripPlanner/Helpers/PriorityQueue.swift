//
//  PriorityQueue.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 05.10.2024.
//

import Foundation

// MARK: - PriorityQueue
public struct PriorityQueue<Element> {

    // MARK: - Properties
    fileprivate var heap = [Element]()
    private let ordered: (Element, Element) -> Bool

    // MARK: - Initializer
    public init(sort: @escaping (Element, Element) -> Bool) {
        self.ordered = sort
    }

    // MARK: - Public Methods
    public var isEmpty: Bool {
        return heap.isEmpty
    }

    public func peek() -> Element? {
        return heap.first
    }

    public mutating func enqueue(_ element: Element) {
        heap.append(element)
        siftUp(heap.count - 1)
    }

    public mutating func dequeue() -> Element? {
        guard !heap.isEmpty else { return nil }
        if heap.count == 1 {
            return heap.removeFirst()
        } else {
            let first = heap[0]
            heap[0] = heap.removeLast()
            siftDown(0)
            return first
        }
    }

    // MARK: - Private Methods
    private mutating func siftUp(_ index: Int) {
        var child = index
        var parent = self.parentIndex(of: child)
        while child > 0 && ordered(heap[child], heap[parent]) {
            heap.swapAt(child, parent)
            child = parent
            parent = self.parentIndex(of: child)
        }
    }

    private mutating func siftDown(_ index: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(of: parent)
            let right = rightChildIndex(of: parent)
            var candidate = parent
            if left < heap.count && ordered(heap[left], heap[candidate]) {
                candidate = left
            }
            if right < heap.count && ordered(heap[right], heap[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            heap.swapAt(parent, candidate)
            parent = candidate
        }
    }

    // MARK: - Helper Methods
    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }
}
