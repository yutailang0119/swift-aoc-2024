import Algorithms
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

  func part2() async throws -> Any {
    var safes = 0
    for entity in entities {
      let report = Report(line: entity)
      if report.isSafe {
        safes += 1
      } else {
        for removed in report.tolerates {
          if Report(line: removed).isSafe {
            safes += 1
            break
          }
        }
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
      line.adjacentPairs()
        .map { $0.1 - $0.0 }
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
