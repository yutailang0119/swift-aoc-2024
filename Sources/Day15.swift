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

  var table: Puzzle.Table<Grid> {
    let lines = entities[0].split(separator: "\n").map { entity in
      entity.compactMap(Day15.Grid.init(rawValue:))
    }
    return Puzzle.Table(lines: lines)
  }

  var moves: [Move] {
    entities[1].compactMap(Move.init(rawValue:))
  }
}

private extension Day15 {
  enum Grid: Character, CustomStringConvertible {
    case robot = "@"
    case box = "O"
    case wall = "#"
    case empty = "."

    var description: String {
      String(rawValue)
    }
  }

  enum Move: Character, CustomStringConvertible {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

    var description: String {
      String(rawValue)
    }
  }
}
