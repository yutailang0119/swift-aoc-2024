import Foundation

struct Day11: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day11 {
  var entities: [Int] {
    data.split(separator: " ").compactMap {
      Int($0.trimmingCharacters(in: .newlines))
    }
  }
}
