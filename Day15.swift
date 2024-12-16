import Foundation

struct Coordinates: Hashable {
    let row: Int
    let column: Int

    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    static func + (lhs: Coordinates, rhs: Coordinates) -> Coordinates {
        return Coordinates(lhs.row + rhs.row, lhs.column + rhs.column)
    }
    
    static func += (lhs: inout Coordinates, rhs: Coordinates) {
        lhs = lhs + rhs
    }
    
    var gps: Int {
        row * 100 + column
    }
}

enum Object {
    case wall, box, robot
    init?(_ character: Character) {
        switch character {
        case "#": self = .wall
        case "O": self = .box
        case "@": self = .robot
        default: return nil
        }
    }
}

enum Move {
    case up, down, left, right
    init(_ character: Character) {
        switch character {
        case "^": self = .up
        case "v": self = .down
        case "<": self = .left
        case ">": self = .right
        default: self = .up
        }
    }
    
    var delta: Coordinates {
        return switch self {
        case .up: Coordinates(-1, 0)
        case .down: Coordinates(1, 0)
        case .left: Coordinates(0, -1)
        case .right: Coordinates(0, 1)
        }

    }
}

func filterCoords(_ coords: [(coords: Coordinates, object: Object?)], by object: Object) -> [Coordinates] {
    return coords
        .filter { $0.object == object }
        .map(\.coords)
}

let lines = String("15.txt", sample: false)
    .components(separatedBy: .newlines)
let parts = lines.split(separator: "")
let map = parts.first ?? []
let movesString = parts.last?.joined() ?? ""

let coords = map
    .enumerated()
    .flatMap { (row, line) in
        line
            .enumerated()
            .map { (column, character) in
                (Coordinates(row, column), object: Object(character))
            }
    }

let walls = Set(filterCoords(coords, by: .wall))
var boxes = Set(filterCoords(coords, by: .box))
var robot = filterCoords(coords, by: .robot).first ?? Coordinates(0, 0)
let moves = movesString.map(Move.init(_:))

for move in moves {
    let nextCoords = robot + move.delta
    var currentCoords = nextCoords
    while boxes.contains(currentCoords) && !walls.contains(currentCoords) {
        currentCoords += move.delta
    }
    guard !walls.contains(currentCoords) else { continue }
    boxes.insert(currentCoords)
    boxes.remove(nextCoords)
    robot = nextCoords
}

let totalGPS = boxes.map(\.gps).reduce(0, +)
print(totalGPS)
