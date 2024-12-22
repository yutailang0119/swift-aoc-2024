import Foundation

struct Day21: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day21 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }
}
