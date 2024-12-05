import Foundation

struct Day05: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }

  private var orderingRules: [OrderingRule] {
    entities[0]
      .split(separator: "\n")
      .map {
        let pages = $0.split(separator: "|").compactMap { Int($0) }
        return OrderingRule(x: pages[0], y: pages[1])
      }
  }

  private var updates: [Update] {
    entities[1]
      .split(separator: "\n")
      .map {
        let pages = $0.split(separator: ",").compactMap { Int($0) }
        return Update(pages: pages)
      }
  }

  func part1() async throws -> Any {
    let orderingRules = self.orderingRules
    let updates = self.updates

    var correctlyUpdates: [Update] = []
    for update in updates {
      let isValid = update.pages
        .adjacentPairs()
        .allSatisfy { orderingRules.contains(OrderingRule(x: $0.0, y: $0.1)) }
      if isValid {
        correctlyUpdates.append(update)
      }
    }

    return correctlyUpdates.reduce(0) { $0 + ($1.pages.center ?? 0) }
  }

  func part2() async throws -> Any {
    let orderingRules = self.orderingRules
    let updates = self.updates

    var reorderedUpdates: [Update] = []
    for update in updates {
      let isValid = update.pages
        .adjacentPairs()
        .allSatisfy { orderingRules.contains(OrderingRule(x: $0.0, y: $0.1)) }
      if !isValid {
        let pages = update.pages.sorted { lhs, rhs in
          orderingRules.contains { $0.x == lhs && $0.y == rhs }
        }
        reorderedUpdates.append(Update(pages: pages))
      }
    }

    return reorderedUpdates.reduce(0) { $0 + ($1.pages.center ?? 0) }
  }
}

private extension Day05 {
  struct OrderingRule: Equatable {
    var x: Int
    var y: Int
  }

  struct Update {
    var pages: [Int]
  }
}
