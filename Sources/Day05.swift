import Foundation

struct Day05: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day05 {
  struct OrderingRule {
    var x: Int
    var y: Int
  }
}
