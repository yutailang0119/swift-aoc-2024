import Foundation
import ToolKit

struct Day20: AdventDay {
  var data: String

  func part1() async throws -> Any {
    _part1(lower: 100)
  }

  func _part1(lower: Int) -> Any {
    let marks = self.entities.map {
      $0.compactMap(Mark.init(rawValue:))
    }
    let positions = marks.enumerated()
      .flatMap { y, row in
        row.enumerated()
          .map { x, mark in (Position(x: x, y: y), mark) }
      }
    let map: [Position: Mark] = Dictionary(positions, uniquingKeysWith: { $1 })

    let start = map.first { $0.value == .start }!.key
    let end = map.first { $0.value == .end }!.key

    let dijkstra = Dijkstra(
      elements: map,
      start: start,
      end: end,
      directions: [.top, .bottom, .left, .right]
    ) { mark in
      mark.map({ $0 != .wall }) ?? false
    }
    let path = dijkstra.path
    let route = Array(path!.enumerated())

    var cheats = [Int: Int]()
    for (picosecond, position) in route {
      let tracks = route[picosecond...].filter { $0.element.distance(to: position) <= 2 }
      for track in tracks {
        let saved = track.offset - picosecond - track.element.distance(to: position)
        cheats[saved, default: 0] += 1
      }
    }

    return cheats.filter { $0.key >= lower }
      .reduce(0) { $0 + $1.value }
  }
}

private extension Day20 {
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
}

private extension Day20 {
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
