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

struct Region: Hashable {
    var plots: Set<Coordinates>
    var type: Character

    init(plots: Set<Coordinates>, type: Character) {
        self.plots = plots
        self.type = type
    }

    var area: Int { plots.count }

    var perimeter: [(Coordinates, Coordinates)] {
        var returnValue: [(Coordinates, Coordinates)] = []
        for plot in plots {
            for neighbor in plot.neighbors {
                if !contains(neighbor) {
                    returnValue.append((plot, neighbor))
                }
            }
        }
        return returnValue
    }

    var cost: Int { area * perimeter.count }

    func contains(_ coords: Coordinates) -> Bool {
        plots.contains(coords)
    }
}

struct GardenMap {
    var plots: [[Character]]
    var regions: [Region]

    init(_ input: String) {
        plots = input
            .components(separatedBy: .newlines)
            .map { line in
                Array(line)
            }

        regions = []
        regions = findRegions()
    }

    subscript(_ coords: Coordinates) -> Character {
        get { plots[coords.row][coords.column] }
    }

    var size: Int { plots.count }

    var allCoordinates: [Coordinates] {
        plots
            .enumerated()
            .flatMap { (row, rowContents) in
                rowContents
                    .enumerated()
                    .map { (column, character) in
                        Coordinates(row, column)
                    }
            }
    }

    var totalCost: Int {
        regions
            .map(\.cost)
            .reduce(0, +)
    }

    func isOnMap(_ coords: Coordinates) -> Bool {
        let range = 0 ..< size
        return range.contains(coords.row) && range.contains(coords.column)
    }

    func findRegion(_ start: Coordinates) -> Set<Coordinates> {
        var toVisit: Set = [start]
        var visited: Set<Coordinates> = []
        while !toVisit.isEmpty {
            let current = toVisit.removeFirst()
            let viableNeighbors = current.neighbors
                .filter(isOnMap(_:))
                .filter { !visited.contains($0) }
                .filter { self[$0] == self[start] }
            visited.insert(current)
            toVisit.formUnion(viableNeighbors)
        }
        return visited
    }

    func findRegions() -> [Region] {
        var returnValue: [Region] = []
        for coords in allCoordinates {
            let alreadyFound = returnValue
                .map { region in
                    region.contains(coords)
                }
                .contains(true)
            if !alreadyFound {
                let plots = findRegion(coords)
                returnValue.append(Region(plots: plots, type: self[coords]))
            }
        }
        return returnValue
    }
}

let input = String("12.txt", sample: false)
let map = GardenMap(input)

// Part 1

print(map.totalCost)
