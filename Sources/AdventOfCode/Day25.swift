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
