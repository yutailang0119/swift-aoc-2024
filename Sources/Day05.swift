import Foundation

struct Day05: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day05 {
  struct OrderingRule {
    var x: Int
    var y: Int
  }
}

private extension Array {
  var center: Element? {
    guard count != 0 else { return nil }

    let i = (count > 1 ? count - 1 : count) / 2
    return self[i]
  }
}
