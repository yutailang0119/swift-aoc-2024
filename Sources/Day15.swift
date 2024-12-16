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

  var table: Puzzle.Table<Tile> {
    let lines = entities[0].split(separator: "\n").map { entity in
      entity.compactMap(Day15.Tile.init(rawValue:))
    }
    return Puzzle.Table(lines: lines)
  }

  var moves: [Move] {
    entities[1].compactMap(Move.init(rawValue:))
  }

  func attempt(move: Move, table: Puzzle.Table<Day15.Tile>) -> Puzzle.Table<Day15.Tile> {
    struct Cursor {
      var tile: Tile
      var positon: Puzzle.Position
    }
    let direction = Puzzle.Direction(move: move)
    let robot = table.positions(for: .robot).first!

    var cursor: Cursor? = Cursor(tile: .robot, positon: robot)
    var moved: [Cursor] = []
    while let c = cursor {
      let p = c.positon.moved(to: direction)
      switch table.element(at: p) {
      case .box:
        moved.append(Cursor(tile: c.tile, positon: p))
        cursor = Cursor(tile: .box, positon: p)
      case .empty:
        moved.append(Cursor(tile: c.tile, positon: p))
        cursor = nil
      case .wall:
        moved.removeAll()
        cursor = nil
      case .robot, nil:
        cursor = nil
      }
    }

    if !moved.isEmpty {
      moved.append(Cursor(tile: .empty, positon: robot))
    }

    var t = table
    for move in moved {
      t.lines[move.positon.y][move.positon.x] = move.tile
    }
    return t
  }
}

private extension Day15 {
  enum Tile: Character, CustomStringConvertible, Equatable {
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
