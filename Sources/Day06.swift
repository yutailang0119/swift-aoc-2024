import Foundation

struct Day06: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day06 {
  enum Grid: String {
    case `guard` = "^"
    case obstruction = "#"
    case dot = "."
  }
}
