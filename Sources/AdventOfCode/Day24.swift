import Foundation

struct Day24: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day24 {
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").map(String.init)
    }
  }
}
