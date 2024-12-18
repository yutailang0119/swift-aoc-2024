import Foundation

struct Day18: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day18 {
  var entities: [String] {
    data.split(separator: "\n")
      .map(String.init)
  }
}

private extension Day18 {
  struct Byte {
    var x: Int
    var y: Int
  }
}
