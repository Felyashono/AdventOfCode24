import Foundation
import RegexBuilder

let memory = String("3.txt", sample: false)

let mulInstructionRegex = Regex {
    "mul("
    TryCapture() {
        Repeat(1...3) { .digit }
    } transform: { Int($0) }
    ","
    TryCapture {
        Repeat(1...3) { .digit }
    } transform: { Int($0) }
    ")"
}

let allInstructionsRegex = Regex {
    ChoiceOf {
        "do()"
        "don't()"
        mulInstructionRegex
    }
}

// Part 1

let mulInstructions = memory.matches(of: mulInstructionRegex)
let total = mulInstructions
    .map { $0.1 * $0.2 }
    .reduce(0, +)
print(total)

// Part 2

let allInstructions = memory.matches(of: allInstructionsRegex)

var enabledTotal = 0
var enabled = true
for instruction in allInstructions {
    let text = instruction.0
    let a = instruction.1
    let b = instruction.2
    
    switch text {
    case "do()": enabled = true
    case "don't()": enabled = false
    default: if enabled { enabledTotal += a! * b! }
    }
}

print(enabledTotal)
