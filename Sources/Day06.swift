import Foundation

struct Day06: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func part1() async throws -> Any {
    let grids = entities.map { $0.compactMap(Grid.init) }
    let table = Puzzle.Table<Grid>(lines: grids)
    guard var cursor = table.positions(for: .guard).first else {
      fatalError("No guard found")
    }

    var routes: Set<Puzzle.Position> = []
    var direction: Puzzle.Direction? = .top
    while let d = direction {
      let route = table.route(from: cursor, to: d, until: .obstruction)
      routes.formUnion(route)
      if let last = route.last,
         table.element(at: last.moved(to: d)) != nil {
        cursor = last
        direction = d.rightDegrees
      } else {
        direction = nil
      }
    }

    return routes.count
  }
}

private extension Day06 {
  enum Grid: String, CustomStringConvertible {
    case `guard` = "^"
    case obstruction = "#"
    case dot = "."

    var description: String {
      self.rawValue
    }
  }
}
