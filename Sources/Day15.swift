import Foundation

struct Day15: AdventDay {
  var data: String

  func part1() async throws -> Any {
    var table = self.table
    let moves = self.moves
    for move in moves {
      table = self.attempt(move: move, table: table)
    }

    return table.positions.joined()
      .filter { $0.0 == .box }
      .reduce(0) { $0 + 100 * $1.1.y + $1.1.x }
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

  func attempt(move: Move, table: Puzzle.Table<Day15.Grid>) -> Puzzle.Table<Day15.Grid> {
    struct Cursor {
      var grid: Grid
      var positon: Puzzle.Position
    }
    let direction = Puzzle.Direction(move: move)
    let robot = table.positions(for: .robot).first!

    var cursor: Cursor? = Cursor(grid: .robot, positon: robot)
    var moved: [Cursor] = []
    while let c = cursor {
      let p = c.positon.moved(to: direction)
      let g = table.element(at: p)!
      switch g {
      case .box:
        moved.append(Cursor(grid: c.grid, positon: p))
        cursor = Cursor(grid: .box, positon: p)
      case .empty:
        moved.append(Cursor(grid: c.grid, positon: p))
        cursor = nil
      case .robot, .wall:
        moved.removeAll()
        cursor = nil
      }
    }

    guard !moved.isEmpty else {
      return table
    }

    var t = table
    t.lines[robot.y][robot.x] = .empty
    for move in moved {
      t.lines[move.positon.y][move.positon.x] = move.grid
    }
    return t
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

private extension Puzzle.Direction {
  init(move: Day15.Move) {
    switch move {
    case .up: self = .top
    case .down: self = .bottom
    case .left: self = .left
    case .right: self = .right
    }
  }
}
