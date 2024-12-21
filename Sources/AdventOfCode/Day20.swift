import Foundation
import ToolKit

struct Day20: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day20 {
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
}

private extension Day20 {
  enum Mark: Character, CustomStringConvertible {
    case start = "S"
    case end = "E"
    case wall = "#"
    case empty = "."

    var description: String {
      String(rawValue)
    }
  }
}

private extension Position {
  func distance(to other: Position) -> Int {
    abs(x - other.x) + abs(y - other.y)
  }
}
