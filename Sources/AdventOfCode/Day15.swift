import Foundation
import ToolKit

struct Day15: AdventDay {
  var data: String

  func part1() async throws -> Any {
    func attempt(move: Move, table: Table<Day15.Tile>) -> Table<Day15.Tile> {
      struct Cell {
        var tile: Tile
        var position: Position
      }

      let direction = Direction(move: move)
      let robot = table.positions(for: .robot).first!

      var cursor: Cell? = Cell(tile: .robot, position: robot)
      var targets: [Cell] = []
      while let c = cursor {
        let nextPosition = c.position.moved(to: direction)
        let nextTile = table[at: nextPosition]!

        switch nextTile {
        case .box:
          targets.append(Cell(tile: c.tile, position: nextPosition))
          cursor = Cell(tile: .box, position: nextPosition)
        case .empty:
          targets.append(Cell(tile: c.tile, position: nextPosition))
          cursor = nil
        case .wall:
          targets.removeAll()
          cursor = nil
        case .robot:
          cursor = nil
        }
      }

      if !targets.isEmpty {
        targets.insert(Cell(tile: .empty, position: robot), at: 0)
      }

      var t = table
      for target in targets {
        t[at: target.position] = target.tile
      }
      return t
    }

    var table = self.tiles
    let moves = self.moves
    for move in moves {
      table = attempt(move: move, table: table)
    }

    return table.tuples.joined()
      .filter { $0.0 == .box }
      .reduce(0) { $0 + 100 * $1.1.y + $1.1.x }
  }

  func part2() async throws -> Any {
    func attempt(move: Move, table: Table<Day15.WideTile>) -> Table<Day15.WideTile> {
      struct Cell {
        var tile: WideTile
        var position: Position

        var description: String {
          "\(tile.description): (x: \(position.x), y: \(position.y))"
        }
      }

      let direction = Direction(move: move)
      let robot = table.positions(for: .robot).first!

      var targets: [[Cell]] = [[Cell(tile: .robot, position: robot)]]
      switch direction {
      case .top, .bottom:
        var cursors: [Cell] = targets.last!
        while !cursors.isEmpty {
          var nexts: [Cell] = []
          for c in cursors {
            let nextPosition = c.position.moved(to: direction)
            let nextTile = table[at: nextPosition]!
            let next = Cell(tile: nextTile, position: nextPosition)

            switch nextTile {
            case .boxLeft:
              nexts.append(next)
              let right = nextPosition.moved(to: .right)
              nexts.append(Cell(tile: .boxRight, position: right))
              if c.tile == .robot || c.tile == .boxRight {
                nexts.append(Cell(tile: .empty, position: right.moved(to: direction.reverse)))
              }
            case .boxRight:
              nexts.append(next)
              let left = nextPosition.moved(to: .left)
              nexts.append(Cell(tile: .boxLeft, position: left))
              if c.tile == .robot || c.tile == .boxLeft {
                nexts.append(Cell(tile: .empty, position: left.moved(to: direction.reverse)))
              }
            case .wall:
              nexts.append(next)
            case .empty:
              continue
            case .robot:
              fatalError("Found robot in \(nextPosition)")
            }
          }
          if nexts.contains(where: { $0.tile == .wall }) {
            targets.removeAll()
            cursors.removeAll()
          } else {
            targets.append(nexts)
            cursors = nexts
          }
          nexts.removeAll()
        }
      case .left, .right:
        var cursor: Cell? = targets.last?.first
        while let c = cursor {
          let nextPosition = c.position.moved(to: direction)
          let nextTile = table[at: nextPosition]!
          switch nextTile {
          case .boxLeft, .boxRight:
            let n = nextPosition.moved(to: direction)
            let box: WideTile = nextTile == .boxLeft ? .boxRight : .boxLeft
            targets.append(
              [
                Cell(tile: nextTile, position: nextPosition),
                Cell(tile: box, position: n),
              ]
            )
            cursor = Cell(tile: box, position: n)
          case .empty:
            cursor = nil
          case .wall:
            targets.removeAll()
            cursor = nil
          case .robot:
            cursor = nil
          }
        }
      default:
        break
      }

      var tbl = table
      if !targets.isEmpty {
        tbl[at: robot] = .empty
      }
      for target in targets.joined() {
        let p = target.position.moved(to: direction)
        tbl[at: p] = target.tile
      }
      for (y, line) in tbl.lines.enumerated() {
        for (x, tile) in line.enumerated() {
          switch tile {
          case .boxLeft:
            tbl[at: Position(x: x + 1, y: y)] = .boxRight
          case .boxRight:
            tbl[at: Position(x: x - 1, y: y)] = .boxLeft
          default:
            break
          }
        }
      }
      return tbl
    }

    var table = self.wideTiles
    let moves = self.moves
    for move in moves {
      table = attempt(move: move, table: table)
    }

    return table.tuples.joined()
      .filter { $0.0 == .boxLeft }
      .reduce(0) { $0 + 100 * $1.1.y + $1.1.x }
  }
}

private extension Day15 {
  var entities: [String] {
    data.split(separator: "\n\n").map(String.init)
  }

  var tiles: Table<Tile> {
    let lines = entities[0].split(separator: "\n").map { entity in
      entity.compactMap(Day15.Tile.init(rawValue:))
    }
    return Table(lines)
  }

  var wideTiles: Table<WideTile> {
    let lines = entities[0].split(separator: "\n")
      .map { entity in entity.compactMap(Day15.Tile.init(rawValue:)) }
      .map { line in
        line.reduce(into: [WideTile]()) {
          switch $1 {
          case .robot: $0.append(contentsOf: [.robot, .empty])
          case .box: $0.append(contentsOf: [.boxLeft, .boxRight])
          case .wall: $0.append(contentsOf: [.wall, .wall])
          case .empty: $0.append(contentsOf: [.empty, .empty])
          }
        }
      }
    return Table(lines)
  }

  var moves: [Move] {
    entities[1].compactMap(Move.init(rawValue:))
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

  enum WideTile: Character, CustomStringConvertible {
    case robot = "@"
    case boxLeft = "["
    case boxRight = "]"
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

private extension Direction {
  init(move: Day15.Move) {
    switch move {
    case .up: self = .top
    case .down: self = .bottom
    case .left: self = .left
    case .right: self = .right
    }
  }
}
