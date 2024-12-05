import Foundation

struct WordSearch {
    let grid: [[Character]]

    init(_ grid: [[Character]]) {
        self.grid = grid
    }
    
    init(_ input: String) {
        let lines = input.components(separatedBy: .newlines)
        grid = lines.map { Array($0) }
    }
    
    func rotatingClockwise() -> WordSearch {
        var newGrid: [[Character]] = []
        for column in 0 ..< grid.count {
            var newRow: [Character] = []
            for row in stride(from: grid.count - 1, through: 0, by: -1) {
                newRow.append(grid[row][column])
            }
            newGrid.append(newRow)
        }
        return WordSearch(newGrid)
    }
    
    func rows() -> [[Character]] {
        return grid
    }
    
    func columns() -> [[Character]] {
        return rotatingClockwise().grid
            .map { $0.reversed() }
    }
    
    // returns an array of elements on diagonals whose slope matches 1
    func positiveDiagonals() -> [[Character]] {
        let maxIndex = grid.count - 1
        let indexRange = 0 ..< grid.count
        var returnValue: [[Character]] = []
        // fill out all the arrays of correct length with " " so that we can index into them later
        var rowLength = 1
        for row in 0 ... (maxIndex) * 2 {
            returnValue.append(.init(repeating: " ", count: rowLength))
            rowLength += (row < maxIndex ? 1 : -1)
        }
        // walk through all cells, mapping their values into the correct arrays of diagonals
        for row in indexRange {
            for column in indexRange {
                let sum = row + column
                returnValue[sum][sum < maxIndex ? column : column - (sum - maxIndex)] = grid[row][column]
            }
        }
        return returnValue
    }
    
    // returns an array of elements on diagonals whose slope matches -1
    func negativeDiagonals() -> [[Character]] {
        return rotatingClockwise().positiveDiagonals()
    }
    
    // returns a 3x3 frame centered at (row,column)
    func frame(_ row: Int, _ column: Int) -> [[Character]] {
        let bounds = 1 ..< grid.count - 1
        guard bounds.contains(row), bounds.contains(column) else { return [] }
        var returnValue: [[Character]] = []
        for frameRow in row - 1 ... row + 1 {
            var newRow: [Character] = []
            for frameColumn in column - 1 ... column + 1 {
                newRow.append(grid[frameRow][frameColumn])
            }
            returnValue.append(newRow)
        }
        return returnValue
    }
}

let puzzle = WordSearch(String("4.txt", sample: false))

// Part 1

let orientations: [[[Character]]] = [puzzle.rows(),
                                     puzzle.rows().map { $0.reversed() },
                                     puzzle.columns(),
                                     puzzle.columns().map { $0.reversed() },
                                     puzzle.positiveDiagonals(),
                                     puzzle.positiveDiagonals().map { $0.reversed() },
                                     puzzle.negativeDiagonals(),
                                     puzzle.negativeDiagonals().map { $0.reversed() }]
let strings = orientations.flatMap { $0.map { String($0) } }

let regex = /XMAS/
let appearanceCount = strings
    .map { $0.matches(of: regex) }
    .map { $0.count }
    .reduce(0, +)
print(appearanceCount)

// Part 2

let r2: [Character] = [".", "A", "."]
let ms: [Character] = ["M", ".", "S"]
let sm: [Character] = ["S", ".", "M"]
let ss: [Character] = ["S", ".", "S"]
let mm: [Character] = ["M", ".", "M"]

let targetFrames = [[ms, r2, ms], [sm, r2, sm], [ss, r2, mm], [mm, r2, ss]]

var frameCounter = 0
for row in 1 ..< puzzle.grid.count - 1 {
    for column in 1 ..< puzzle.grid.count - 1 {
        var frame = puzzle.frame(row, column)
        frame[0][1] = "."
        frame[2][1] = "."
        frame[1][0] = "."
        frame[1][2] = "."
        if targetFrames.contains(frame) {
            frameCounter += 1
        }
    }
}

print(frameCounter)
