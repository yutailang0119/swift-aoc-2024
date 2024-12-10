import Foundation

struct Day06: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let grids = entities.map { $0.compactMap(Grid.init) }
    let table = Puzzle.Table<Grid>(lines: grids)
    let route = self.route(in: table)
    return Set(route).count
  }

  func part2() async throws -> Any {
    let grids = entities.map { $0.compactMap(Grid.init) }
    let table = Puzzle.Table<Grid>(lines: grids)
    var route = Set(self.route(in: table))

    guard let `guard` = table.positions(for: .guard).first else {
      fatalError("No guard found")
    }
    route.remove(`guard`)

    let looped = await withTaskGroup(of: Bool.self) { group in
      for position in route {
        group.addTask {
          var t = table
          t.lines[position.y][position.x] = .obstruction

          var routes: [[Puzzle.Position]] = []
          var cursor = `guard`
          var direction: Puzzle.Direction = .top
          var looped: Bool? = nil
          while looped == nil {
            let route = t.route(from: cursor, to: direction, until: .obstruction)
            if routes.contains(route) {
              looped = true
            } else {
              if !route.isEmpty {
                routes.append(route)
              }
              if let last = routes.joined().last,
                t.element(at: last.moved(to: direction)) == .obstruction
              {
                cursor = last
                direction = direction.rightDegrees
              } else {
                looped = false
              }
            }
          }
          return looped!
        }
      }

      var looped: [Bool] = []
      for await g in group {
        looped.append(g)
      }
      return looped
    }

    return looped.count { $0 }
  }
}

private extension Day06 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func route(in table: Puzzle.Table<Grid>) -> [Puzzle.Position] {
    var routes: [[Puzzle.Position]] = []
    var cursor: Puzzle.Position? = table.positions(for: .guard).first
    var direction: Puzzle.Direction = .top
    while let c = cursor {
      let route = table.route(from: c, to: direction, until: .obstruction)
      if routes.contains(route) {
        cursor = nil
      } else {
        if !route.isEmpty {
          routes.append(route)
        }
        if let last = routes.joined().last,
          table.element(at: last.moved(to: direction)) == .obstruction
        {
          cursor = last
          direction = direction.rightDegrees
        } else {
          cursor = nil
        }
      }
    }
    return Array(routes.joined())
  }
}

private extension Day06 {
  enum Grid: String, Sendable, CustomStringConvertible {
    case `guard` = "^"
    case obstruction = "#"
    case dot = "."

    var description: String {
      self.rawValue
    }
  }
}
