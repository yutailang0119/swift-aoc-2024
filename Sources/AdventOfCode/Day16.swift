import Collections
import Foundation
import ToolKit

struct Day16: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let marks = self.entities.map {
      $0.compactMap(Mark.init(rawValue:))
    }
    let positions = marks.enumerated()
      .flatMap { y, row in
        row.enumerated()
          .map { x, mark in (Position(x: x, y: y), mark) }
      }
    let maze: [Position: Mark] = Dictionary(positions, uniquingKeysWith: { $1 })

    let start = maze.first { $0.value == .start }!.key
    let end = maze.first { $0.value == .end }!.key

    let paths = Dijkstra.paths(from: start, to: end, in: maze)

    return paths.map(\.score).min()!
  }

  func part2() async throws -> Any {
    let marks = self.entities.map {
      $0.compactMap(Mark.init(rawValue:))
    }
    let positions = marks.enumerated()
      .flatMap { y, row in
        row.enumerated()
          .map { x, mark in (Position(x: x, y: y), mark) }
      }
    let maze: [Position: Mark] = Dictionary(positions, uniquingKeysWith: { $1 })

    let start = maze.first { $0.value == .start }!.key
    let end = maze.first { $0.value == .end }!.key

    let paths = Dijkstra.paths(from: start, to: end, in: maze)

    let min = paths.map(\.score).min()!
    let pths = paths.filter({ $0.score == min })

    var spots: Set<Position> = []
    for path in pths {
      spots.formUnion(path.path)
    }

    return spots.count
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

  enum Dijkstra {}
}

private extension Day16.Dijkstra {
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
    var weight: Int
    var path: Set<Position>

    var nexts: [Context] {
      [context.forward, context.clockwise, context.counterClockwise]
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
      lhs.weight < rhs.weight
    }
  }

  struct Path {
    var path: Set<Position>
    var score: Int
  }

  static func paths(
    from start: Position,
    to end: Position,
    in dictionary: [Position: Day16.Mark]
  ) -> [Path] {
    var scores = [Node.Context(position: start, direction: .right): 0]
    var paths: [Path] = []

    var heap = Heap<Node>()
    heap.insert(
      Node(context: Node.Context(position: start, direction: .right), weight: 0, path: [start])
    )

    while let node = heap.popMin() {
      if node.context.position == end {
        paths.append(Path(path: node.path, score: node.weight))
        continue
      }

      var nds: [Node] = []
      for next in node.nexts {
        if !node.path.contains(next.position),
          dictionary[next.position]! != .wall
        {
          let add = node.context.direction == next.direction ? 1 : 1001
          nds.append(
            Node(context: next, weight: node.weight + add, path: node.path.union([next.position]))
          )
        }
      }

      for nd in nds {
        let previous = scores[nd.context]

        if previous == nil || nd.weight <= previous! {
          scores[nd.context] = nd.weight

          heap.insert(nd)
        }
      }
    }

    return paths
  }
}
