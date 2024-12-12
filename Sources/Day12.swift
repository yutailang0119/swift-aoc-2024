import Foundation

struct Day12: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day12 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }
}

private extension Day12 {
  struct Plant {
    var element: String
    var position: Puzzle.Position
  }
}
