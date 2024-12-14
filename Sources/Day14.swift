import Foundation
import RegexBuilder

struct Day14: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

extension Day14 {
  struct Space {
    var wide: Int
    var tall: Int
  }

  struct Quadrant {
    var all: [Puzzle.Position] = []
    var science: [Puzzle.Position] = []
    var teachers: [Puzzle.Position] = []
    var crazy: [Puzzle.Position] = []
  }
}

private extension Day14 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
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
