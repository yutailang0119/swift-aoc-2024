import Algorithms
import Foundation
import ToolKit

struct Day25: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let marks = entities.map { entity in
      entity.map { $0.compactMap(Mark.init(rawValue:)) }
    }
    var keys: [Schematic] = []
    var locks: [Schematic] = []

    for mark in marks {
      if mark.first!.allSatisfy({ $0 == .filled }) {
        keys.append(Schematic(rows: mark))
      } else if mark.last!.allSatisfy({ $0 == .filled }) {
        locks.append(Schematic(rows: mark))
      }
    }

    var count = 0
    for (key, lock) in product(keys, locks) {
      if zip(key.heights, lock.heights).allSatisfy({ $0 + $1 <= 5 }) {
        count += 1
      }
    }

    return count
  }
}

private extension Day25 {
  var entities: [[[Character]]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").map {
        Array($0)
      }
    }
  }
}

private extension Day25 {
  struct Schematic {
    var rows: [[Mark]]

    var heights: [Int] {
      rows.transposed().map { column in
        column.count { $0 == .filled } - 1
      }
    }
  }

  enum Mark: Character, CustomStringConvertible {
    case filled = "#"
    case empty = "."

    var description: String {
      String(rawValue)
    }
  }
}
