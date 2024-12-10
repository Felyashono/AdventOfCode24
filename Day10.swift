import Foundation

struct Coordinates: Hashable {
    let row: Int
    let column: Int
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    var neighbors: [Coordinates] {
        [Coordinates(row - 1, column),
         Coordinates(row + 1, column),
         Coordinates(row, column - 1),
         Coordinates(row, column + 1)]
    }
}

struct TopographicalMap {
    var contents: [[Int]]
    
    init(_ input: String) {
        contents = input
            .components(separatedBy: .newlines)
            .map { line in
                line.compactMap { character in
                    Int(String(character))
                }
            }
    }
    
    subscript(_ coords: Coordinates) -> Int {
        get { contents[coords.row][coords.column] }
    }
    
    var size: Int { contents.count }
    
    var trailHeads: [Coordinates] {
        contents
            .enumerated()
            .flatMap { (row, rowContents) in
                rowContents
                    .enumerated()
                    .filter { (column, height) in
                        height == 0
                    }
                    .map { (column, height) in
                        Coordinates(row, column)
                    }
            }
    }
    
    func isOnMap(_ coords: Coordinates) -> Bool {
        let range = 0 ..< size
        return range.contains(coords.row) && range.contains(coords.column)
    }
    
    func summits(from currentCoordinates: Coordinates) -> Set<Coordinates> {
        let height = self[currentCoordinates]
        guard height < 9 else { return [currentCoordinates] }
        let neighbors = currentCoordinates.neighbors
            .filter(isOnMap(_:))
            .filter { self[$0] == height + 1}
        guard neighbors.count > 0 else { return [] }
        return neighbors
            .map { summits(from: $0) }
            .reduce([]) { $0.union($1) }
    }
    
    func trails(from currentCoordinates: Coordinates) -> Int {
        let height = self[currentCoordinates]
        guard height < 9 else { return 1 }
        let neighbors = currentCoordinates.neighbors
            .filter(isOnMap(_:))
            .filter { self[$0] == height + 1}
        guard neighbors.count > 0 else { return 0 }
        return neighbors
            .map { trails(from: $0) }
            .reduce(0, +)
    }
}


let input = String("10.txt", sample: false)
let topoMap = TopographicalMap(input)

// Part 1

let summitsTotal = topoMap
    .trailHeads
    .map { topoMap.summits(from: $0) }
    .map(\.count)
    .reduce(0, +)
print(summitsTotal)

// Part 2

let trailsTotal = topoMap
    .trailHeads
    .map { topoMap.trails(from: $0) }
    .reduce(0, +)
print(trailsTotal)
