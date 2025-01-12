import Foundation
import ToolKit

struct Day12: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let t = Table(entities)
    let table = Table<Plant>(t.tuples.map { $0.map(Plant.init) })

    return regions(in: table).reduce(into: 0) {
      $0 += perimeters(for: $1, in: table) * $1.count
    }
  }

  func part2() async throws -> Any {
    let t = Table(entities)
    let table = Table<Plant>(t.tuples.map { $0.map(Plant.init) })

    return regions(in: table).reduce(into: 0) {
      $0 += sides(for: $1, in: table) * $1.count
    }
  }
}

private extension Day12 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func regions(in table: Table<Plant>) -> [Set<Plant>] {
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

  func region(from plant: Plant, in table: Table<Plant>) -> Set<Plant> {
    var contained: Set<Position> = []
    var regions: Set<Plant> = []
    var line: Set<Plant> = [plant]
    while !line.isEmpty {
      let (xs, ys) = explore(from: line, with: &contained, in: table)
      regions.formUnion(xs)
      regions.formUnion(ys)
      line = ys
    }
    return regions
  }

  func explore(
    from plants: Set<Plant>,
    with contained: inout Set<Position>,
    in table: Table<Plant>
  ) -> (xs: Set<Plant>, ys: Set<Plant>) {
    guard let plant = plants.first else {
      return (plants, [])
    }
    var xs: Set<Plant> = plants
    contained.formUnion(plants.map(\.position))
    for plant in plants {
      for direction in [Direction.left, .right] {
        var plnt: Plant? = plant
        while let p = plnt {
          let position = p.position.moved(to: direction)
          if contained.contains(position) {
            plnt = nil
          } else {
            if let element = table[at: position],
              element.element == plant.element
            {
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
      for direction in [Direction.top, .bottom] {
        var plnt: Plant? = x
        while let p = plnt {
          let position = p.position.moved(to: direction)
          if contained.contains(position) {
            plnt = nil
          } else {
            if let element = table[at: position],
              element.element == plant.element
            {
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

  func perimeters(for region: Set<Day12.Plant>, in table: Table<Day12.Plant>) -> Int {
    var perimeters = 0
    for r in region {
      for direction in [Direction.top, .right, .bottom, .left] {
        let position = r.position.moved(to: direction)
        let next = table[at: position]
        if next?.element != r.element {
          perimeters += 1
        }
      }
    }
    return perimeters
  }

  func sides(for region: Set<Day12.Plant>, in table: Table<Day12.Plant>) -> Int {
    var sides = 0
    for r in region {
      for direction in [Direction.top, .right, .bottom, .left] {
        let next = table[at: r.position.moved(to: direction)]
        if next.flatMap({ !region.contains($0) }) ?? true {
          do {
            let moved = r.position.moved(to: direction.counterClockwise)
            if let rotated = table[at: moved],
              region.contains(rotated)
            {
              let e = table[at: moved.moved(to: direction)]
              if e.flatMap({ !region.contains($0) }) ?? true,
                moved < r
              {
                continue
              }
            }
          }

          do {
            let moved = r.position.moved(to: direction.clockwise)
            if let rotated = table[at: moved],
              region.contains(rotated)
            {
              let e = table[at: moved.moved(to: direction)]
              if e.flatMap({ !region.contains($0) }) ?? true,
                moved < r
              {
                continue
              }
            }
          }
          sides += 1
        }
      }
    }
    return sides
  }
}

private extension Day12 {
  struct Plant: Hashable, CustomStringConvertible, Sendable {
    var element: String
    var position: Position

    var description: String {
      "\(element): (\(position.x), \(position.y))"
    }
  }
}

private func < (position: Position, plant: Day12.Plant) -> Bool {
  if position.y < plant.position.y { return true }
  if position.y > plant.position.y { return false }
  return position.x < plant.position.x
}
