import Foundation
import ToolKit

struct Day18: AdventDay {
  var data: String

  func part1() async throws -> Any {
    _part1(nanosecond: 1024, in: Space(wide: 70, tall: 70))
  }

  func _part1(nanosecond: Int, in space: Space) -> Any {
    let bytes = self.entities.map {
      let splited = $0.split(separator: ",")
      return Byte(x: Int(splited[0])!, y: Int(splited[1])!)
    }
    let fallen = bytes.prefix(nanosecond)
    let positions = Array(repeating: Array(repeating: Mark.empty, count: space.wide + 1), count: space.tall + 1).enumerated()
      .flatMap { y, row in
        row.enumerated()
          .map { x, mark in
            let m = fallen.contains { $0.x == x && $0.y == y } ? Mark.wall : mark
            return (Position(x: x, y: y), m)
          }
      }
    let memories: [Position: Mark] = Dictionary(positions, uniquingKeysWith: { $1 })

    let start = Position.zero
    let end = Position(x: space.wide, y: space.tall)

    let paths = Dijkstra.paths(from: start, to: end, in: memories)

    return paths.first?.positions.filter { $0 != .zero }.count ?? 0
  }
}

extension Day18 {
  struct Space {
    var wide: Int
    var tall: Int
  }
}

private extension Day18 {
  var entities: [String] {
    data.split(separator: "\n")
      .map(String.init)
  }
}

private extension Day18 {
  struct Byte {
    var x: Int
    var y: Int
  }

  enum Mark: Character, CustomStringConvertible {
    case wall = "#"
    case empty = "."

    var description: String {
      String(rawValue)
    }
  }

  enum Dijkstra {}
}

private extension Day18.Dijkstra {
  struct Path: Hashable {
    var positions: Set<Position>
    var weight: Int
  }

  struct Node: Comparable {
    struct Context: Hashable {
      var position: Position
      var direction: Direction

      var forward: Self {
        Self(position: position.moved(to: direction), direction: direction)
      }

      var clockwise: Self {
        let direction = self.direction.clockwise
        return Self(position: position.moved(to: direction), direction: direction)
      }

      var counterClockwise: Self {
        let direction = self.direction.counterClockwise
        return Self(position: position.moved(to: direction), direction: direction)
      }
    }

    var context: Context
    var path: Path

    var nexts: [Context] {
      [context.forward, context.clockwise, context.counterClockwise]
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
      lhs.path.weight < rhs.path.weight
    }
  }

  static func paths(
    from start: Position,
    to end: Position,
    in dictionary: [Position: Day18.Mark]
  ) -> [Path] {
    var weights: [Node.Context: Int] = [Node.Context(position: start, direction: .right): 0]
    var heap = Heap<Node>()
    heap.insert(
      Node(context: Node.Context(position: start, direction: .right), path: Path(positions: [start], weight: 0))
    )

    var paths: [Path] = []
    while let node = heap.popMin() {
      if node.context.position == end {
        paths.append(node.path)
        continue
      }

      var nds: [Node] = []
      for next in node.nexts {
        let mark = dictionary[next.position]
        if !node.path.positions.contains(next.position),
           mark.map({ $0 != .wall }) ?? false
        {
          nds.append(
            Node(
              context: next,
              path: Path(positions: node.path.positions.union([next.position]), weight: node.path.weight + 1)
            )
          )
        }
      }

      for nd in nds {
        let previous = weights[nd.context]
        if previous == nil || nd.path.weight < previous! {
          weights[nd.context] = nd.path.weight

          heap.insert(nd)
        }
      }
    }

    return paths
  }
}
