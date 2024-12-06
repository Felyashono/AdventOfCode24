import Foundation

struct Coordinates: Equatable, CustomStringConvertible, Hashable {
    let row: Int
    let column: Int
    
    var isOnMap: Bool {
        let range = 0 ..< gridSize
        return range.contains(row) && range.contains(column)
    }
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    init(_ triple: (row: Int, column: Int, Character)) {
        self.row = triple.row
        self.column = triple.column
    }
    
    var description: String {
        "(\(row), \(column))"
    }
}

enum Direction {
    case east, west, north, south
}

struct PatrolGuard {
    var position: Coordinates
    var heading: Direction = .north

    init(_ position: Coordinates) {
        self.position = position
    }
    
    func nextTile() -> Coordinates {
        return switch heading {
        case .north: Coordinates(position.row - 1, position.column)
        case .south: Coordinates(position.row + 1, position.column)
        case .east: Coordinates(position.row, position.column + 1)
        case .west: Coordinates(position.row, position.column - 1)
        }
    }
    
    func isBlocked() -> Bool {
        return obstacles.contains { $0 == nextTile() }
    }
    
    mutating func turnRight() {
        heading = switch heading {
        case .north: .east
        case .south: .west
        case .east: .south
        case .west: .north
        }
    }
    
    mutating func moveForward() {
        position = nextTile()
    }
}

func mapTile(_ triple: (row: Int, column: Int, character: Character), equals character: Character) -> Bool {
    return triple.character == character
}

let input = String("6.txt", sample: true)
let lines = input.components(separatedBy: .newlines)
let gridSize = lines.count
let mapWithCoordinates = lines
    .enumerated()
    .flatMap { (row, string) in
        string
            .enumerated()
            .map { (column, character) in
                (row, column, character)
            }
    }
let obstacles = mapWithCoordinates
    .filter { mapTile($0, equals: "#") }
    .map(Coordinates.init)
let guardCoordinates = mapWithCoordinates
    .filter { mapTile($0, equals: "^") }
    .map(Coordinates.init)
    .first!
var patrolGuard = PatrolGuard(guardCoordinates)

// Part 1

var visitedTiles: Set<Coordinates> = [patrolGuard.position]
while patrolGuard.position.isOnMap {
    while patrolGuard.isBlocked() {
        patrolGuard.turnRight()
    }
    patrolGuard.moveForward()
    visitedTiles.insert(patrolGuard.position)
}
print(visitedTiles.count - 1)
