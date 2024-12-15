import Foundation

struct Robot {
    let x: Int
    let y: Int
    let dx: Int
    let dy: Int

    init(input: String) {
        let halves = input
            .components(separatedBy: " ")
            .map { $0
                .components(separatedBy: "=")
                .last?
                .components(separatedBy: ",")
                .compactMap(Int.init)
                ?? []
            }
        let startPosition = halves.first
        let velocity = halves.last
        x = startPosition?.first ?? 0
        y = startPosition?.last ?? 0
        dx = velocity?.first ?? 0
        dy = velocity?.last ?? 0
    }

    func position(time: Int) -> (x: Int, y: Int) {
        return (x: component(x, dx, maxX), y: component(y, dy, maxY))

        func component(_ x: Int, _ dx: Int, _ max: Int) -> Int {
            let raw = (x + dx * time) % max
            guard raw >= 0 else { return max + raw }
            return raw
        }
    }
}

let maxX = 101
let maxY = 103
let t = 100
let lines = String("14.txt", sample: false)
    .components(separatedBy: .newlines)
let robots = lines
    .map(Robot.init)

// Part 1

let endPositions = robots
    .map { $0.position(time: t) }
let halfX = Double(maxX) / 2.0
let halfY = Double(maxY) / 2.0
let left = 0 ..< Int(floor(halfX))
let right = Int(ceil(halfX)) ..< maxX
let top = 0 ..< Int(floor(halfY))
let bottom = Int(ceil(halfY)) ..< maxY
let q1Count = endPositions.count { left.contains($0.x) && top.contains($0.y) }
let q2Count = endPositions.count { right.contains($0.x) && top.contains($0.y) }
let q3Count = endPositions.count { left.contains($0.x) && bottom.contains($0.y) }
let q4Count = endPositions.count { right.contains($0.x) && bottom.contains($0.y) }
let quadrantCounts = [q1Count, q2Count, q3Count, q4Count]
let safetyFactor = quadrantCounts.reduce(1, *)
print(safetyFactor)
