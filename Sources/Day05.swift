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

    var rightUpdates: [Update] = []
    loop: for update in updates {
      var afters = update.pages
      while !afters.isEmpty {
        let page = afters.removeFirst()
        let beforeRules = orderingRules.filter { $0.y == page }.map(\.x)
        if afters.contains(where: { beforeRules.contains($0) }) {
          continue loop
        }
      }
      rightUpdates.append(update)
    }

    return rightUpdates.reduce(0) { $0 + ($1.pages.center ?? 0) }
  }

  func part2() async throws -> Any {
    let orderingRules = self.orderingRules
    let updates = self.updates

    var incorrectlyUpdates: [Update] = []
    loop: for update in updates {
      var afters = update.pages
      while !afters.isEmpty {
        let page = afters.removeFirst()
        let beforeRules = orderingRules.filter { $0.y == page }.map(\.x)
        if afters.contains(where: { beforeRules.contains($0) }) {
          incorrectlyUpdates.append(update)
          continue loop
        }
      }
    }

    var reorderedUpdates: [Update] = []
    for incorrectlyUpdate in incorrectlyUpdates {
      let pages = incorrectlyUpdate.pages.sorted { lhs, rhs in
          orderingRules.contains(where: { $0.x == lhs && $0.y == rhs })
        }
      reorderedUpdates.append(Update(pages: pages))
    }

    return reorderedUpdates.reduce(0) { $0 + ($1.pages.center ?? 0) }
  }
}

private extension Day05 {
  struct OrderingRule {
    var x: Int
    var y: Int
  }

  struct Update {
    var pages: [Int]
  }
}

private extension Array {
  var center: Element? {
    guard count != 0 else { return nil }

    let i = (count > 1 ? count - 1 : count) / 2
    return self[i]
  }
}
