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

  func path(nanosecond: Int, in space: Space) -> Dijkstra<Mark>.Path? {
    let bytes = self.entities.map {
      let splited = $0.split(separator: ",")
      return Byte(x: Int(splited[0])!, y: Int(splited[1])!)
    }
    let fallen = bytes.prefix(nanosecond)
    let positions = Array(repeating: Array(repeating: Mark.empty, count: space.wide + 1), count: space.tall + 1)
      .enumerated()
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

    let dijkstra =  Dijkstra(
      elements: memories,
      start: start,
      end: end,
      directions: [.top, .bottom, .left, .right]
    ) { mark in
      mark.map({ $0 != .wall }) ?? false
    }
    return dijkstra.path
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
}
