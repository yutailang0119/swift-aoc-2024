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

  private var equations: [Equation] {
    entities.compactMap {
      let splited =  $0.split(separator: ": ")
      guard let test = Int(splited[0]) else {
        return nil
      }
      let numbers = splited[1].split(separator: " ").compactMap { Int($0) }
      return Equation(test: test, numbers: numbers)
    }
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
