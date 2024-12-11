import Foundation

func blinkStone(_ stone: Int) -> [Int] {
    if stone == 0 { return [1] }
    let string = String(stone)
    if string.count.isMultiple(of: 2) {
        return [string.prefix(string.count / 2), string.suffix(string.count / 2)]
            .map(String.init)
            .compactMap(Int.init)
    }
    return [stone * 2024]
}

struct CacheKey: Hashable {
    let stone, blinks: Int
}

var countCache: [CacheKey : Int] = [:]

func count(_ stones: [Int], blinks: Int) -> Int {
    guard blinks > 0 else { return stones.count }
    return stones.map { stone in
        let cacheKey = CacheKey(stone: stone, blinks: blinks)
        if let result = countCache[cacheKey] {
            return result
        }
        let result = count(blinkStone(stone), blinks: blinks - 1)
        countCache[cacheKey] = result
        return result
    }
    .reduce(0, +)
}

var stones = String("11.txt", sample: false)
    .components(separatedBy: " ")
    .compactMap(Int.init)

// Part 1

print(count(stones, blinks: 25))

// Part 2

print(count(stones, blinks: 75))
