import Foundation

enum Instruction: Int {
    case adv = 0, bxl, bst, jnz, bxc, out, bdv, cdv
    
    init?(_ opCode: Int) {
        self.init(rawValue: opCode)
    }
    
    var operandType: OperandType {
        return switch self {
        case .adv, .bdv, .cdv, .bst, .out: .combo
        case .bxl, .jnz, .bxc: .literal
        }
    }
}

enum OperandType {
    case literal, combo
}

struct Computer {
    var a, b, c: Int
    let program: [Int]
    var ip: Int
    var output = ""
    
    init(_ input: String) {
        let lines = input.components(separatedBy: .newlines)
        let registers = lines[0 ..< 3]
            .compactMap { $0.components(separatedBy: " ").last }
            .compactMap(Int.init)
        a = registers[0]
        b = registers[1]
        c = registers[2]
        
        program = lines.last?
            .components(separatedBy: " ")
            .last?
            .components(separatedBy: ",")
            .compactMap(Int.init) ?? []
        
        ip = 0
    }
    
    mutating func executeNextInstruction() {
        guard let instruction = Instruction(program[ip]) else { return }
        let operand = resolveOperand(instruction.operandType, value: program[ip + 1])
        switch instruction {
        case .adv: a = a / Int(pow(2.0, Double(operand)))
        case .bxl: b = b ^ operand
        case .bst: b = operand % 8
        case .jnz: if a != 0 { ip = operand - 2 }
        case .bxc: b = b ^ c
        case .out: output += (output == "" ? "" : ",") + "\(operand % 8)"
        case .bdv: b = a / Int(pow(2.0, Double(operand)))
        case .cdv: c = a / Int(pow(2.0, Double(operand)))
        }
    }
    
    mutating func run() -> String {
        while ip < program.count {
            executeNextInstruction()
            ip += 2
        }
        return output
    }
    
    func resolveOperand(_ operand: OperandType, value: Int) -> Int {
        switch (operand, value) {
        case (.literal, _): return value
        case (.combo, 4): return a
        case (.combo, 5): return b
        case (.combo, 6): return c
        default: return value
        }
    }
}

let input = String("17.txt", sample: false)
let computer = Computer(input)

// Part 1

var comp = computer
let output = comp.run()
print(output)
