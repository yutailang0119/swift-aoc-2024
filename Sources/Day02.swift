import Foundation

struct Day02: AdventDay {
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() async throws -> Any {
    fatalError()
  }
}

extension Day02 {
  private struct Report {
    var line: [Int]

    var distances: [Int] {
      var distances: [Int] = []
      var current: Int?
      for n in line {
        if let c = current {
          distances.append(n - c)
        }
        current = n
      }
      return distances
    }
  }
}
