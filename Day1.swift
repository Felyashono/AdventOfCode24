import Foundation

func similarity(_ element: Int, _ list: [Int]) -> Int {
    return element * list.count(where: { $0 == element })
}

let inputPairs = String("1.txt", sample: false)
    .components(separatedBy: .newlines)
    .map { $0.components(separatedBy: "   ") }
let leftList = inputPairs
    .compactMap(\.first)
    .compactMap(Int.init)
let rightList = inputPairs
    .compactMap(\.last)
    .compactMap(Int.init)

// Part 1

let pairs = zip(leftList.sorted(), rightList.sorted())
let totalDistance = pairs
    .map { abs($0.0 - $0.1) }
    .reduce(0, +)

// Part 2

let similarityScore = leftList
    .map { similarity($0, rightList) }
    .reduce(0, +)
