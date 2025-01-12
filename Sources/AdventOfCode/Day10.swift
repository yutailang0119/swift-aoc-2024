import Foundation
import ToolKit

struct Day10: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let table = Table(entities)

    let trailheads = table.positions(for: 0)
      .map { Height(scale: 0, position: $0) }

    var sum = 0
    for trailhead in trailheads {
      let stps = steps(from: [trailhead], to: [.top, .bottom, .left, .right], in: table)
      let reaches = stps.compactMap {
        $0.map(\.scale) == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] ? $0.last : nil
      }
      sum += Set(reaches).count
    }
    return sum
  }

  func part2() async throws -> Any {
    let table = Table(entities)

    let trailheads = table.positions(for: 0)
      .map { Height(scale: 0, position: $0) }

    var sum = 0
    for trailhead in trailheads {
      let stps = steps(from: [trailhead], to: [.top, .bottom, .left, .right], in: table)
      let reaches = stps.filter { $0.map(\.scale) == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }
      sum += reaches.count
    }
    return sum
  }
}

private extension Day10 {
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.compactMap { Int(String($0)) }
    }
  }

  func steps(from routes: [Height], to directions: [Direction], in table: Table<Int>) -> [[Height]] {
    guard let last = routes.last,
      last.scale < 9
    else {
      return [routes]
    }
    var stps: [[Height]] = []
    for direction in directions {
      let p = last.position.moved(to: direction)
      guard let scl = table[at: p] else {
        continue
      }
      let next = Height(scale: scl, position: p)
      if next.scale == last.scale + 1 {
        stps.append(contentsOf: steps(from: routes + [next], to: directions, in: table))
      } else {
        stps.append(routes + [next])
      }
    }
    return stps
  }
}

private extension Day10 {
  struct Height: Hashable, CustomStringConvertible {
    var scale: Int
    var position: Position

    var description: String {
      "\(scale): (\(position.x), \(position.y))"
    }
  }
}
