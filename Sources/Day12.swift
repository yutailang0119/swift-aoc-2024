import Foundation

struct Day12: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day12 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func regions(in table: Puzzle.Table<Plant>) -> [Set<Plant>] {
    var regions: [Set<Plant>] = []
    var contained: Set<Plant> = []
    for line in table.lines {
      for plant in line {
        if contained.contains(plant) {
          continue
        }
        let region = region(from: plant, in: table)
        regions.append(region)
        contained.formUnion(region)
      }
    }

    return regions
  }

  func region(from plant: Plant, in table: Puzzle.Table<Plant>) -> Set<Plant> {
    var contained: Set<Puzzle.Position> = []

    func explore(from plants: Set<Plant>, in table: Puzzle.Table<Plant>) -> (xs: Set<Plant>, ys: Set<Plant>) {
      var xs: Set<Plant> = plants
      contained.formUnion(plants.map(\.position))
      for plant in plants {
        for direction in [Puzzle.Direction.left, .right] {
          var plnt: Plant? = plant
          while let p = plnt {
            let position = p.position.moved(to: direction)
            if contained.contains(position) {
              plnt = nil
            } else {
              if let element = table.element(at: position),
                 element.element == plant.element {
                contained.insert(position)
                xs.insert(element)
                plnt = element
              } else {
                plnt = nil
              }
            }
          }
        }
      }

      var ys: Set<Plant> = []
      for x in xs {
        for direction in [Puzzle.Direction.top, .bottom] {
          var plnt: Plant? = x
          while let p = plnt {
            let position = p.position.moved(to: direction)
            if contained.contains(position) {
              plnt = nil
            } else {
              if let element = table.element(at: position),
                 element.element == plant.element {
                contained.insert(position)
                ys.insert(element)
                plnt = element
              } else {
                plnt = nil
              }
            }
          }
        }
      }

      return (xs, ys)
    }

    var regions: Set<Plant> = []
    var line: Set<Plant> = [plant]
    while !line.isEmpty {
      let (xs, ys) = explore(from: line, in: table)
      regions.formUnion(xs)
      regions.formUnion(ys)
      line = ys
    }
    return regions
  }
}

private extension Day12 {
  struct Plant: Hashable, CustomStringConvertible {
    var element: String
    var position: Puzzle.Position

    var description: String {
      "\(element): (\(position.x), \(position.y))"
    }
  }
}
