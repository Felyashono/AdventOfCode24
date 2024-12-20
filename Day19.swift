import Foundation

let sections = String("19.txt", sample: false)
    .components(separatedBy: .newlines)
    .split(separator: "")
    .map(Array.init)
let availablePatterns = sections
    .first?
    .first?
    .components(separatedBy: ", ") ?? []
let desiredPatterns = sections.last ?? []
var knownPossiblePatterns: Set<String> = []
var knownImpossiblePatters: Set<String> = []

func isPossible(_ desiredPattern: String) -> Bool {
    guard desiredPattern.count > 0 else { return true }
    let possibleAvailablePatterns = availablePatterns.filter { desiredPattern.hasPrefix($0) }
    guard possibleAvailablePatterns.count > 0 else { return false }
    for possibleAvailablePattern in possibleAvailablePatterns {
        let subPattern = String(desiredPattern.dropFirst(possibleAvailablePattern.count))
        if knownPossiblePatterns.contains(subPattern) { return true }
        if knownImpossiblePatters.contains(subPattern) { continue }
        if isPossible(subPattern) {
            knownPossiblePatterns.insert(desiredPattern)
            return true
        }
    }
    knownImpossiblePatters.insert(desiredPattern)
    return false
}

// Part 1

let possiblePatternsCount = desiredPatterns.count { isPossible($0) }
print(possiblePatternsCount)
