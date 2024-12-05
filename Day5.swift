import Foundation

func mayPrecede(_ a: Int, _ b: Int) -> Bool {
    return !rules[b, default: []].contains(a)
}

func mayPrecede(_ a: Int, _ b: [Int]) -> Bool {
    return b
        .map { mayPrecede(a, $0) }
        .allSatisfy { $0 }
}

func isInCorrectOrder(_ array: [Int]) -> Bool {
    guard array.count > 1 else { return true }
    let first = array.first!
    let rest = Array(array.dropFirst())
    if !mayPrecede(first, rest) { return false }
    return isInCorrectOrder(rest)
}

extension Array {
    var middle: Element {
        self[(count / 2)]
    }
}

let sections = String("5.txt", sample: false)
    .components(separatedBy: .newlines)
    .split(separator: "")
let rules = sections[0]
    .map { $0.components(separatedBy: "|") }
    .map { (Int($0[0]) ?? 0, Int($0[1]) ?? 0) }
    .reduce(into: [Int : [Int]]()) { partial, next in
        let (a, b) = next
        partial[a, default: []].append(b)
    }
let updates = sections[1]
    .map { $0.components(separatedBy: ",") }
    .map { $0.compactMap(Int.init) }

// Part 1

let correctOrderMiddleSum = updates
    .filter(isInCorrectOrder)
    .map{ $0.middle }
    .reduce(0, +)
print(correctOrderMiddleSum)

// Part 2

let incorrectOrderMiddleSum = updates
    .filter { !isInCorrectOrder($0) }
    .map { $0.sorted(by: mayPrecede(_:_:)) }
    .map { $0.middle }
    .reduce(0, +)
print(incorrectOrderMiddleSum)
