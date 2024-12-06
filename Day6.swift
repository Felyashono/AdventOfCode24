import Foundation

struct Coordinates: Equatable, Hashable {
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
}

enum Direction {
    case east, west, north, south
}

struct PatrolGuard {
    var position: Coordinates
    var heading: Direction = .north
    let obstacles: [Coordinates]
    
    init(_ position: Coordinates, _ obstacles: [Coordinates]) {
        self.position = position
        self.obstacles = obstacles
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

func checkForLoop(_ obstacles: [Coordinates]) -> Bool {
    var patrolGuard = PatrolGuard(guardCoordinates, obstacles)
    var visitedTiles: [Coordinates : Set<Direction>] = [:]
    while patrolGuard.position.isOnMap {
        if visitedTiles[patrolGuard.position, default: []].contains(patrolGuard.heading) {
            return true
        }
        visitedTiles[patrolGuard.position, default: []].insert(patrolGuard.heading)
        while patrolGuard.isBlocked() {
            patrolGuard.turnRight()
        }
        patrolGuard.moveForward()
    }
    return false
}

let lines = String("6.txt", sample: true)
    .components(separatedBy: .newlines)
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

// Part 1

var patrolGuard = PatrolGuard(guardCoordinates, obstacles)
var visitedTiles: [Coordinates : Set<Direction>] = [:]
while patrolGuard.position.isOnMap {
    visitedTiles[patrolGuard.position, default: []].insert(patrolGuard.heading)
    while patrolGuard.isBlocked() {
        patrolGuard.turnRight()
    }
    patrolGuard.moveForward()
}
print(visitedTiles.count)

// Part 2

let allNewObstacles = visitedTiles
    .keys
    .map { coordinates in
        var newObstacles = obstacles
        newObstacles.append(coordinates)
        return newObstacles
    }
let loopsCount = allNewObstacles
    .map { return checkForLoop($0) }
    .count(where: { $0 })
print(loopsCount)
