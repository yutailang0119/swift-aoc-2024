import Foundation

struct Day02: AdventDay {
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() async throws -> Any {
    var safes = 0
    for entity in entities {
      if Report(line: entity).isSafe {
        safes += 1
      }
    }
    return safes
  }
}

extension Day02 {
  private struct Report {
    var line: [Int]

    var isSafe: Bool {
      let sign = distances.allSatisfy { $0 > 0 } || distances.allSatisfy { $0 < 0 }
      let differ = distances.allSatisfy { abs($0) <= 3 }
      return sign && differ
    }

    private var distances: [Int] {
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

    var tolerates: [[Int]] {
      var removed: [[Int]] = []
      for i in (0..<line.count) {
        var l = line
        l.remove(at: i)
        removed.append(l)
      }
      return removed
    }
  }
}
