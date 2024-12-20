import Foundation
import ToolKit

struct Day08: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let frequencies = Set(entities.joined()).filter { $0 != "." }
    let table = Table(entities)

    var antinodes: Set<Position> = []
    for frequency in frequencies {
      let antennas = table.positions(for: frequency)
      for combination in antennas.combinations(ofCount: 2) {
        let lhs = combination[0]
        let rhs = combination[1]

        let p = lhs - rhs

        let antinode1 = lhs + p
        if table[at: antinode1] != nil {
          antinodes.insert(antinode1)
        }

        let antinode2 = rhs - p
        if table[at: antinode2] != nil {
          antinodes.insert(antinode2)
        }
      }
    }

    return antinodes.count
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let frequencies = Set(entities.joined()).filter { $0 != "." }
    let table = Table(entities)

    var antinodes: Set<Position> = []
    for frequency in frequencies {
      let antennas = table.positions(for: frequency)
      for combination in antennas.combinations(ofCount: 2) {
        let lhs = combination[0]
        let rhs = combination[1]

        let p = lhs - rhs

        var antinode1: Position? = lhs + p
        while let a = antinode1 {
          if table[at: a] != nil {
            antinodes.insert(a)
            antinode1 = a + p
          } else {
            antinode1 = nil
          }
        }

        var antinode2: Position? = rhs - p
        while let a = antinode2 {
          if table[at: a] != nil {
            antinodes.insert(a)
            antinode2 = a - p
          } else {
            antinode2 = nil
          }
        }
      }
    }

    var t = table
    for antinode in antinodes {
      t[at: antinode] = "#"
    }

    let count = t.lines.reduce(0) { c, line in
      c + line.count { $0 != "." }
    }

    return count
  }
}

private extension Day08 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }
}
