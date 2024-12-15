import Foundation

struct Day15: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day15 {
  var entities: [String] {
    data.split(separator: "\n\n").map(String.init)
  }
}

private extension Day15 {
  enum Grid: Character {
    case robot = "@"
    case box = "O"
    case wall = "#"
    case empty = "."
  }

  enum Move: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
  }
}
