import Foundation

struct Day19: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let patterns = entities[0].map(Pattern.init(value:))
    let designs = entities[1].map { Design(value: $0) }

    var memo: [Design: Int] = [:]
    let possibles = designs.map { self.available(patterns: patterns, design: $0, memo: &memo) }
    return possibles.count { $0 != 0 }
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let patterns = entities[0].map(Pattern.init(value:))
    let designs = entities[1].map { Design(value: $0) }

    var memo: [Design: Int] = [:]
    let possibles = designs.map { self.available(patterns: patterns, design: $0, memo: &memo) }
    return possibles.reduce(0, +)
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

  func available(patterns: [Pattern], design: Design, memo: inout [Design: Int]) -> Int {
    guard !design.value.isEmpty else {
      return 1
    }
    if let count = memo[design] {
      return count
    } else {
      var count = 0
      for pattern in patterns {
        if design.value.hasPrefix(pattern.value) {
          count += available(
            patterns: patterns,
            design: Design(value: String(design.value.trimmingPrefix(pattern.value))),
            memo: &memo
          )
        }
      }

      memo[design] = count
      return count
    }
  }
}

private extension Day19 {
  struct Pattern {
    var value: String
  }

  struct Design: Hashable {
    var value: String
  }
}
