import Foundation
import ToolKit

struct Day18: AdventDay {
  var data: String

  func part1() async throws -> Any {
    _part1(nanosecond: 1024, in: Space(wide: 70, tall: 70))
  }

  func part2() async throws -> Any {
    _part2(nanosecond: 1024, in: Space(wide: 70, tall: 70))
  }

  func _part1(nanosecond: Int, in space: Space) -> Any {
    let path = path(nanosecond: nanosecond, in: space)
    return path?.positions.filter { $0 != .zero }.count ?? 0
  }

  func _part2(nanosecond: Int, in space: Space) -> Any {
    let bytes = self.entities.map {
      let splited = $0.split(separator: ",")
      return Byte(x: Int(splited[0])!, y: Int(splited[1])!)
    }

    var corrupt: Byte?
    var path = path(nanosecond: nanosecond, in: space)
    for i in (nanosecond + 1)..<bytes.count {
      let last = bytes.prefix(i).last!
      if path?.positions.contains(where: { $0.x == last.x && $0.y == last.y }) ?? false {
        let pth = self.path(nanosecond: i, in: space)
        if pth == nil {
          corrupt = last
          break
        }
        path = pth
      }
    }
    return corrupt?.description ?? ""
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

  func path(nanosecond: Int, in space: Space) -> Dijkstra.Path? {
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

    return Dijkstra.path(from: start, to: end, in: memories)
  }
}

private extension Day18 {
  struct Byte: CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String {
      "\(x),\(y)"
    }
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
    var position: Position
    var path: Path

    var nexts: [Position] {
      [
        position.moved(to: .top),
        position.moved(to: .bottom),
        position.moved(to: .left),
        position.moved(to: .right),
      ]
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
      lhs.path.weight < rhs.path.weight
    }
  }

  static func path(
    from start: Position,
    to end: Position,
    in dictionary: [Position: Day18.Mark]
  ) -> Path? {
    var weights: [Position: Int] = [start: 0]
    var heap = Heap<Node>()
    heap.insert(
      Node(position: start, path: Path(positions: [start], weight: 0))
    )

    var path: Path? = nil
    while let node = heap.popMin() {
      if node.position == end {
        path = node.path
        break
      }

      var nds: [Node] = []
      for next in node.nexts {
        let mark = dictionary[next]
        if !node.path.positions.contains(next),
           mark.map({ $0 != .wall }) ?? false
        {
          nds.append(
            Node(
              position: next,
              path: Path(positions: node.path.positions.union([next]), weight: node.path.weight + 1)
            )
          )
        }
      }

      for nd in nds {
        let previous = weights[nd.position]
        if previous == nil || nd.path.weight < previous! {
          weights[nd.position] = nd.path.weight

          heap.insert(nd)
        }
      }
    }

    return path
  }
}
