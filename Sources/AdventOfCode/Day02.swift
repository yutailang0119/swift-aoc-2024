import Algorithms
import Foundation

struct Day02: AdventDay {
  var data: String

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
        for combination in report.combinations {
          if Report(line: combination).isSafe {
            safes += 1
            break
          }
        }
      }
    }
    return safes
  }
}

private extension Day02 {
  private var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }
}

private extension Day02 {
  struct Report {
    var line: [Int]

    var isSafe: Bool {
      let diffs = self.diffs
      return diffs.allSatisfy { -3..<0 ~= $0 }
        || diffs.allSatisfy { 1...3 ~= $0 }
    }

    private var diffs: [Int] {
      line.adjacentPairs()
        .map { $0.1 - $0.0 }
    }

    var combinations: [[Int]] {
      Array(line.combinations(ofCount: line.count - 1))
    }
  }
}
