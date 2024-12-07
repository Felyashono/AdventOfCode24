import Foundation

enum Operator {
    case add, multiply, concatenate
    
    func compute(lhs: Int, rhs: Int) -> Int {
        return switch self {
        case .add: lhs + rhs
        case .multiply: lhs * rhs
        case .concatenate: Int(String(lhs) + String(rhs)) ?? 0
        }
    }
}

struct Equation {
    let testValue: Int
    let numbers: [Int]
    
    init(line: String) {
        let sides = line.components(separatedBy: ":")
        testValue = Int(sides[0]) ?? 0
        numbers = sides[1]
            .components(separatedBy: " ")
            .compactMap(Int.init)
    }
    
    var operatorCount: Int { numbers.count - 1 }
    
    func isSatisfied(_ operators: [Operator]) -> Bool {
        guard operators.count == operatorCount else { return false }
        let result = (0 ..< operatorCount).reduce(numbers[0]) { total, index in
            return operators[index].compute(lhs: total, rhs: numbers[index + 1])
        }
        return result == testValue
    }
    
    func isSatisfiableWithTwoOperators(_ operators: [Operator] = []) -> Bool {
        if operators.count == operatorCount {
            return isSatisfied(operators)
        }
        return (isSatisfiableWithTwoOperators(operators + [.add]) ||
                isSatisfiableWithTwoOperators(operators + [.multiply]))
    }
    
    func isSatisfiableWithThreeOperators(_ operators: [Operator] = []) -> Bool {
        if operators.count == operatorCount {
            return isSatisfied(operators)
        }
        return (isSatisfiableWithThreeOperators(operators + [.add]) ||
                isSatisfiableWithThreeOperators(operators + [.multiply]) ||
                isSatisfiableWithThreeOperators(operators + [.concatenate])
        )
    }
}

let input = String("7.txt", sample: false)
let lines = input.components(separatedBy: .newlines)
let equations = lines.map(Equation.init)

// Part 1

let totalWithTwoOperators = equations
    .filter { $0.isSatisfiableWithTwoOperators() }
    .map(\.testValue)
    .reduce(0, +)
print(totalWithTwoOperators)

// Part 2

let totalWithThreeOperators = equations
    .filter { $0.isSatisfiableWithThreeOperators() }
    .map(\.testValue)
    .reduce(0, +)
print(totalWithThreeOperators)
