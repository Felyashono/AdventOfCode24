import Foundation

struct DiskMap {
    var contents: [Int]
    
    init(_ input: String) {
        contents = Array(input)
            .map { Int("\($0)")! }
    }
    
    var maxFileID: Int {
        contents.count / 2
    }
    
    func fileLength(_ fileID: Int) -> Int {
        contents[fileID * 2]
    }
}

struct Disk {
    let map: DiskMap
    var contents: [Int?]
    
    init(_ diskMap: DiskMap) {
        map = diskMap
        contents = []
        for (offset, value) in diskMap.contents.enumerated() {
            for _ in 0 ..< value {
                contents.append(offset.isMultiple(of: 2) ? offset / 2: nil)
            }
        }
    }
    
    var checkSum: Int {
        contents
            .enumerated()
            .map { (offset, fileID) in offset * (fileID ?? 0) }
            .reduce(0, +)
    }
    
    func indexOfNextFree(from startingIndex: Int) -> Int {
        var currentIndex = startingIndex
        while contents[currentIndex] != nil {
            currentIndex += 1
        }
        return currentIndex
    }
    
    func isFree(from startingIndex: Int, length: Int) -> Bool {
        contents[startingIndex ..< startingIndex + length].allSatisfy { $0 == nil }
    }
    
    mutating func blockFragment() {
        var nextFree = 0
        var nextBlockToMove = contents.count - 1
        nextFree = indexOfNextFree(from: nextFree)
        while nextBlockToMove > nextFree {
            if let fileID = contents[nextBlockToMove] {
                contents[nextFree] = fileID
                contents[nextBlockToMove] = nil
                while contents[nextFree] != nil {
                    nextFree += 1
                }
            }
            nextBlockToMove -= 1
        }
    }
    
    mutating func fileFragment() {
        var fileEnd = contents.count
        fileLoop: for fileID in stride(from: map.maxFileID, through: 0, by: -1) {
            while contents[fileEnd - 1] != fileID {
                fileEnd -= 1
            }
            let fileLength = map.fileLength(fileID)
            let fileStart = fileEnd - fileLength
            
            var nextFree = indexOfNextFree(from: 0)
            if nextFree + fileLength >= fileEnd { continue fileLoop }
            while !isFree(from: nextFree, length: fileLength) {
                nextFree = indexOfNextFree(from: nextFree + 1)
                if nextFree + fileLength >= fileEnd { continue fileLoop }
            }
            
            for nextDestination in nextFree ..< nextFree + fileLength {
                contents[nextDestination] = fileID
            }
            for nextDestination in fileStart ..< fileEnd {
                contents[nextDestination] = nil
            }
        }
    }
}

let input = String("9.txt", sample: false)
let diskMap = DiskMap(input)
var disk = Disk(diskMap)
var disk2 = disk

// Part 1

disk.blockFragment()
print(disk.checkSum)

// Part 2

disk2.fileFragment()
print(disk2.checkSum)
