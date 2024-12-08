import Foundation
import CollectionConcurrencyKit

struct Antenna: Hashable {
    let row: Int
    let column: Int
    let frequency: Character
    
    init(_ row: Int, _ column: Int, _ frequency: Character) {
        self.row = row
        self.column = column
        self.frequency = frequency
    }
    
    var isInBounds: Bool {
        let bounds = 0 ..< gridSize
        return bounds.contains(row) && bounds.contains(column)
    }
}

struct AntennaPair: Hashable {
    let a: Antenna
    let b: Antenna
    
    init(_ a: Antenna, _ b: Antenna) {
        self.a = a
        self.b = b
    }
    
    var antinodes: [Antenna] {
        let deltaRow = b.row - a.row
        let deltaColumn = b.column - a.column
        let antinode1 = Antenna(b.row + deltaRow, b.column + deltaColumn, "#")
        let antinode2 = Antenna(a.row - deltaRow, a.column - deltaColumn, "#")
        return [antinode1, antinode2]
    }
    
    var resonantAntinodes: [Antenna] {
        let deltaRow = b.row - a.row
        let deltaColumn = b.column - a.column
        var returnValue: [Antenna] = []
        var nextAntinode = Antenna(b.row, b.column, "#")
        while nextAntinode.isInBounds {
            returnValue.append(nextAntinode)
            nextAntinode = Antenna(nextAntinode.row + deltaRow, nextAntinode.column + deltaColumn, "#")
        }
        nextAntinode = Antenna(a.row, a.column, "#")
        while nextAntinode.isInBounds {
            returnValue.append(nextAntinode)
            nextAntinode = Antenna(nextAntinode.row - deltaRow, nextAntinode.column - deltaColumn, "#")
        }
        return returnValue
    }
}

func pairwiseCombinations(_ antennas: [Antenna]) -> Set<AntennaPair> {
    var returnValue: Set<AntennaPair> = []
    for antenna1 in antennas {
        for antenna2 in antennas {
            guard antenna1 != antenna2 else { continue }
            let pair = AntennaPair(antenna1, antenna2)
            let pairReversed = AntennaPair(antenna2, antenna1)
            guard !returnValue.contains(pair), !returnValue.contains(pairReversed) else { continue }
            returnValue.insert(pair)
        }
    }
    return returnValue
}

let lines = String("8.txt", sample: false)
    .components(separatedBy: "\n")
let gridSize = lines.count
let antennas = lines
    .enumerated()
    .flatMap { (row, lineString) in
        lineString
            .enumerated()
            .map { (column, frequency) in
                Antenna(row, column, frequency)
            }
    }
    .filter { $0.frequency != "." }
let antennasByFrequency = Dictionary(grouping: antennas, by: \.frequency)
let antennaPairs = antennasByFrequency
    .values
    .flatMap(pairwiseCombinations(_:))

// Part 1

let antiNodes = antennaPairs
    .flatMap(\.antinodes)
    .filter(\.isInBounds)
let antiNodesCount = Set(antiNodes)
    .count
print(antiNodesCount)

// Part 2

let resonantAntiNodes = antennaPairs
    .flatMap(\.resonantAntinodes)
let resonantAntiNodesCount = Set(resonantAntiNodes)
    .count
print(resonantAntiNodesCount)
