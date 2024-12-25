import Foundation

struct Day25: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
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
