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
    let route = self.route(in: table)
    return Set(route).count
  }

  private func route(in table: Puzzle.Table<Grid>) -> [Puzzle.Position] {
    var routes: [[Puzzle.Position]] = []
    var direction: Puzzle.Direction = .top
    var cursor: Puzzle.Position? = table.positions(for: .guard).first
    while let c = cursor {
      let route = table.route(from: c, to: direction, until: .obstruction)
      if routes.contains(route) {
        cursor = nil
      } else {
        if !route.isEmpty {
          routes.append(route)
        }
        if let last = routes.flatMap({ $0 }).last,
           table.element(at: last.moved(to: direction)) == .obstruction {
          cursor = last
          direction = direction.rightDegrees
        } else {
          cursor = nil
        }
      }
    }
    return routes.flatMap { $0 }
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
