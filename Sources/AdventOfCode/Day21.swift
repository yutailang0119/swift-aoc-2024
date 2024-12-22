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

private extension Day21 {
  struct Input {
    var rawValue: String

    var number: Int {
      Int(String(rawValue.dropLast(1))) ?? 0
    }
  }

  enum NumericKeypad: Character, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case a = "A"
  }

  enum DirectionalKeypad: Character, CaseIterable {
    case up = "^"
    case left = "<"
    case down = "v"
    case right = ">"
    case a = "A"

    init?(rawValue: Character) {
      switch rawValue {
      case "^": self = .up
      case "<": self = .left
      case "v": self = .down
      case ">": self = .right
      case "A": self = .a
      default: return nil
      }
    }

    init(direction: Direction) {
      switch direction {
      case .top: self = .up
      case .bottom: self = .down
      case .left: self = .left
      case .right: self = .right
      default: fatalError()
      }
    }
  }
}
