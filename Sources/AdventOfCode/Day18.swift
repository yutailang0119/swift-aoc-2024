import Foundation

struct Day18: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
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
}

private extension Day18 {
  struct Byte {
    var x: Int
    var y: Int
  }
}
