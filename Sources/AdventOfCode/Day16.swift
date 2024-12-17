import Collections
import Foundation
import ToolKit

struct Day16: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day16 {
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
}

private extension Day16 {
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
