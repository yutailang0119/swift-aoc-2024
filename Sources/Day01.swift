import Foundation

struct Day01: AdventDay {
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: "   ").compactMap { Int($0) }
    }
  }

  func part1() async throws -> Any {
    let lists = entities.transposed()
    let leftList = lists[0]
    let rightList = lists[1]

    return zip(leftList.sorted(), rightList.sorted())
      .map { abs($0.1 - $0.0) }
      .reduce(0, +)
  }

  func part2() async throws -> Any {
    let lists = entities.transposed()
    let leftList = lists[0]
    let rightList = lists[1]

    return
      leftList
      .map { left in
        let count = rightList.count { $0 == left }
        return left * count
      }
      .reduce(0, +)
  }
}
