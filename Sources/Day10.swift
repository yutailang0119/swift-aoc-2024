import Foundation

struct Day10: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day10 {
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.compactMap { Int(String($0)) }
    }
  }
}
