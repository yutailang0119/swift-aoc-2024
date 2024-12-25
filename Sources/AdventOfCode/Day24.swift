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

private extension Day24 {
  struct Wire {
    var name: String
    var bool: Bool
  }

  struct Gate {
    enum Operation: String {
      case and = "AND"
      case or = "OR"
      case xor = "XOR"

      func operate(_ a: Bool, _ b: Bool) -> Bool {
        switch self {
        case .and:
          return a && b
        case .or:
          return a || b
        case .xor:
          return (a || b) && !(a && b)
        }
      }
    }

    var a: String
    var b: String
    var operation: Operation
    var output: String
  }
}
