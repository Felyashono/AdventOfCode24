import Foundation

let adventDirectory = "/Users/home/Coding/Advent of Code/"
let yearDirectory = "Advent of Code 24/"
let inputDirectory = "Inputs/"
let sampleInputDirectory = "SampleInputs/"

public func readAdventData(_ fileName: String, sample: Bool) -> String {
    let url = URL(fileURLWithPath: adventDirectory + yearDirectory + (sample ? sampleInputDirectory : inputDirectory) + fileName)
    guard let string = try? String(contentsOf: url, encoding: .utf8) else { print("Could not read file at \(url)"); return ""}
    return string
}

extension String {
    public init(_ fileName: String, sample: Bool) {
        self = readAdventData(fileName, sample: sample)
    }
}
