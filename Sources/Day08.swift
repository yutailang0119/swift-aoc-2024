import Foundation

struct Day08: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func part1() async throws -> Any {
    let entities = self.entities
    let frequencies = Set(entities.flatMap { $0 }).filter { $0 != "." }
    let table = Puzzle.Table(lines: entities)

    var antinodes: Set<Puzzle.Position> = []
    for frequency in frequencies {
      let antennas = table.positions(for: frequency)
      for combination in antennas.combinations(ofCount: 2) {
        let lhs = combination[0]
        let rhs = combination[1]

        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y

        let antinode1 = Puzzle.Position(x: lhs.x + x, y: lhs.y + y)
        if table.element(at: antinode1) != nil {
          antinodes.insert(antinode1)
        }

        let antinode2 = Puzzle.Position(x: rhs.x - x, y: rhs.y - y)
        if table.element(at: antinode2) != nil {
          antinodes.insert(antinode2)
        }
      }
    }

    return antinodes.count
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let frequencies = Set(entities.flatMap { $0 }).filter { $0 != "." }
    let table = Puzzle.Table(lines: entities)

    var antinodes: Set<Puzzle.Position> = []
    for frequency in frequencies {
      let antennas = table.positions(for: frequency)
      for combination in antennas.combinations(ofCount: 2) {
        let lhs = combination[0]
        let rhs = combination[1]

        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y

        var antinode1: Puzzle.Position? = Puzzle.Position(x: lhs.x + x, y: lhs.y + y)
        while let a = antinode1 {
          if table.element(at: a) != nil {
            antinodes.insert(a)
            antinode1 = Puzzle.Position(x: a.x + x, y: a.y + y)
          } else {
            antinode1 = nil
          }
        }

        var antinode2: Puzzle.Position? = Puzzle.Position(x: rhs.x - x, y: rhs.y - y)
        while let a = antinode2 {
          if table.element(at: a) != nil {
            antinodes.insert(a)
            antinode2 = Puzzle.Position(x: a.x - x, y: a.y - y)
          } else {
            antinode2 = nil
          }
        }
      }
    }

    var t = table
    for antinode in antinodes {
      t.lines[antinode.y][antinode.x] = "#"
    }

    let count = t.lines.reduce(0) { c, line in
      c + line.count { $0 != "." }
    }

    return count
  }
}
