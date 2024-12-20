import Foundation

struct Day19: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day19 {
  var entities: [[String]] {
    let splited = data.split(separator: "\n\n")
    var outputs: [[String]] = []
    outputs.append(splited[0].split(separator: ", ").map(String.init))
    outputs.append(splited[1].split(separator: "\n").map(String.init))
    return outputs
  }
}

private extension Day19 {
  struct Pattern {
    var value: String
  }

  struct Design {
    var value: String
  }
}
