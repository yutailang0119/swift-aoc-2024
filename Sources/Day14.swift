import Foundation
import RegexBuilder

struct Day14: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let space = Space(wide: 101, tall: 103)
    return _part1(after: 100, in: space)
  }

  func _part1(after: Int, in space: Space) -> Any {
    let robots = move(robots: entities.compactMap(\.robot), after: after, in: space)

    let xAxis = space.wide / 2
    let yAxis = space.tall / 2

    var all: [Puzzle.Position] = []
    var science: [Puzzle.Position] = []
    var teachers: [Puzzle.Position] = []
    var crazy: [Puzzle.Position] = []
    for robot in robots {
      if robot.position.x > xAxis && robot.position.y > yAxis {
        all.append(robot.position)
      } else if robot.position.x < xAxis && robot.position.y > yAxis {
       science.append(robot.position)
      } else if robot.position.x < xAxis && robot.position.y < yAxis {
        teachers.append(robot.position)
      } else if robot.position.x > xAxis && robot.position.y < yAxis {
        crazy.append(robot.position)
      }
    }

    return all.count * science.count * teachers.count * crazy.count
  }

  func _part2(in space: Space) -> Any {
    var current = 0
    var reference = 0
    for second in 1..<space.wide * space.tall {
      let robots = move(robots: entities.compactMap(\.robot), after: second, in: space)
      let positions = Set(robots.map(\.position))
      var horizontal = 0
      for position in positions {
        let left = position.moved(to: .left)
        if positions.contains(where: { $0 == left }) {
          horizontal += 1
        }

        let right = position.moved(to: .right)
        if positions.contains(where: { $0 == right }) {
          horizontal += 1
        }
      }

      if horizontal > reference {
        let lines = space.table(for: robots).lines.map { line in
          line.map { $0 == 0 ? "." : "#" }
        }
        let t = Puzzle.Table<String>(lines: lines)
        print("\(second): \(Array(repeating: "=", count: space.wide).joined())")
        print(t)
        print("\n")
        reference = horizontal
        current = second
      }
    }
    return current
  }
}

extension Day14 {
  struct Space {
    var wide: Int
    var tall: Int
  }
}

private extension Day14 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  func move(robots: [Robot], after seconds: Int, in space: Day14.Space) -> [Robot] {
    var moved: [Robot] = []
    for var robot in robots {
      robot.position = robot.move(seconds: seconds, in: space)
      moved.append(robot)
    }

    return moved
  }
}

private extension Day14.Space {
  func table(for robots: [Day14.Robot]) -> Puzzle.Table<Int> {
    var table = Puzzle.Table<Int>(lines: Array(repeating: Array(repeating: 0, count: wide), count: tall))
    for robot in robots {
      table.lines[robot.position.y][robot.position.x] += 1
    }
    return table
  }
}

private extension Day14 {
  struct Robot {
    struct Velocity {
      var x: Int
      var y: Int
    }

    var position: Puzzle.Position
    var velocity: Velocity
  }
}

private extension Day14.Robot {
  func move(seconds: Int, in space: Day14.Space) -> Puzzle.Position {
    var position = self.position
    let movedX = (position.x + velocity.x * seconds) % space.wide
    let movedY = (position.y + velocity.y * seconds) % space.tall

    if movedX < 0 {
      position.x = space.wide + movedX
    } else if movedX >= space.wide {
      position.x = movedX
    } else {
      position.x = movedX
    }

    if movedY < 0 {
      position.y = space.tall + movedY
    } else if movedY >= space.tall {
      position.y = movedY
    } else {
      position.y = movedY
    }

    assert(0..<space.wide ~= position.x)
    assert(0..<space.tall ~= position.y)

    return position
  }
}

private extension String {
  var robot: Day14.Robot? {
    let regex = Regex {
      One("p=")
      Capture {
        ZeroOrMore("-")
        OneOrMore(.digit)
      }
      One(",")
      Capture {
        ZeroOrMore("-")
        OneOrMore(.digit)
      }
      One(" ")
      One("v=")
      Capture {
        ZeroOrMore("-")
        OneOrMore(.digit)
      }
      One(",")
      Capture {
        ZeroOrMore("-")
        OneOrMore(.digit)
      }
    }

    guard let match = firstMatch(of: regex) else {
      return nil
    }
    return Day14.Robot(
      position: Puzzle.Position(x: Int(match.1)!, y: Int(match.2)!),
      velocity: Day14.Robot.Velocity(x: Int(match.3)!, y: Int(match.4)!)
    )
  }
}
