import Foundation

struct Day13: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day13 {
  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }
}

private extension Day13 {
  struct Machine {
    struct Claw {
      var x: Int
      var y: Int
    }

    var buttonA: Claw
    var buttonB: Claw
    var prize: Claw
  }
}
