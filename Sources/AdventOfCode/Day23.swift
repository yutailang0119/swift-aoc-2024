import Foundation

struct Day23: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day23 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }
}

private extension Day23 {
  struct Connection {
    var a: String
    var b: String
  }

  struct Computer {
    var name: String
    var connections: Set<String>
  }
}
