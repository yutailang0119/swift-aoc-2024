import Foundation

struct Day13: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day13 {
  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }
}
