import Foundation

struct Day14: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day14 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }
}

private extension Day14 {
  struct Robot {
    struct Velocity {
      var x: Int
      var y: Int
    }

    var position: Puzzle.Position
    var velocity: Velocity
  }
}
