import Foundation

struct Day07: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n")
      .map(String.init)
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day07 {
  struct Equation {
    var test: Int
    var numbers: [Int]
  }

  enum Operator {
    case add
    case multiple
  }
}
