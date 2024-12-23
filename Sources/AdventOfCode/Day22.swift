import Foundation

struct Day22: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day22 {
  var entities: [Int] {
    data.split(separator: "\n")
      .compactMap { Int(String($0)) }
  }
}
