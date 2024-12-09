import Foundation

struct Day09: AdventDay {
  var data: String

  var entities: [Int] {
    data.compactMap { Int(String($0)) }
  }

  func part1() async throws -> Any {
    0
  }
}
