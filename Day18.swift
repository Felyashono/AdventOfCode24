import Foundation

struct Coordinates: Hashable {
    let row: Int
    let column: Int
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    init(_ input: String) {
        let coords = input
            .components(separatedBy: ",")
            .compactMap(Int.init)
        self.row = coords.last ?? 0
        self.column = coords.first ?? 0
    }
    
    var neighbors: [Coordinates] {
        [Coordinates(row - 1, column),
         Coordinates(row + 1, column),
         Coordinates(row, column - 1),
         Coordinates(row, column + 1)]
    }
    
    var isInBounds: Bool {
        let bounds = 0 ..< size
        return bounds.contains(row) && bounds.contains(column)
    }
}

func pathLength(numberFallen: Int) -> Int? {
    let fallen = Set(corrupted[0 ..< numberFallen])
    var distances: [Coordinates : Int] = [:]
    var coordsQueue: [Coordinates] = [end]
    while distances[start] == nil {
        guard !coordsQueue.isEmpty else { return nil }
        let currentCoords = coordsQueue.removeFirst()
        let neighbors = currentCoords.neighbors.filter(\.isInBounds)
        distances[currentCoords] = (neighbors.compactMap { distances[$0] }.min() ?? -1) + 1
        coordsQueue.append(contentsOf: neighbors.filter { distances[$0] == nil && !fallen.contains($0) && !coordsQueue.contains($0) })
    }
    return distances[start]
}

let sample = false
let size = sample ? 7 : 71
let numberFallen = sample ? 12 : 1024
let start = Coordinates(0, 0)
let end = Coordinates(size - 1, size - 1)
let corrupted = String("18.txt", sample: sample)
    .components(separatedBy: .newlines)
    .map(Coordinates.init)

// Part 1

print(pathLength(numberFallen: numberFallen)!)

// Part 2

var found = false
var i = numberFallen
while !found {
    if pathLength(numberFallen: i) == nil {
        found = true
    } else {
        i += 1
    }
}

print(corrupted[i - 1])
