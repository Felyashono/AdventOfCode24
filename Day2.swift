struct Report {
    var levels: [Int]
    
    var deltas: [Int] {
        levels
            .enumerated()
            .dropFirst()
            .reduce(into: [Int]()) { partial, next in
                partial.append(next.element - levels[next.offset - 1])
            }
    }
    
    var isSafe: Bool {
        (deltas.allSatisfy { $0 > 0 } ||
         deltas.allSatisfy { $0 < 0 }
        ) &&
        deltas.allSatisfy { (1...3).contains(abs($0)) }
    }
    
    var isSafeWithDampener: Bool {
        (0..<levels.count)
            .map { removingLevel(at: $0) }
            .map(\.isSafe)
            .contains(true)
    }
    
    func removingLevel(at index: Int) -> Report {
        var copy = self
        copy.levels.remove(at: index)
        return copy
    }
    
    init(_ line: String) {
        levels = line
            .components(separatedBy: " ")
            .compactMap(Int.init)
    }
}

let reports = String("2.txt", sample: false)
    .components(separatedBy: .newlines)
    .map(Report.init)

// Part 1

let safeCount = reports
    .map(\.isSafe)
    .count { $0 }
print("Part 1: \(safeCount)")

// Part 2

let safeCountWithDampener = reports
    .map(\.isSafeWithDampener)
    .count { $0 }
print("Part 2: \(safeCountWithDampener)")
