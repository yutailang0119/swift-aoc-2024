import Foundation

struct Day01: AdventDay {
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: "   ").compactMap { Int($0) }
    }
  }

  func part1() async throws -> Any {
    0
  }
}
