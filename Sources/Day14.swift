import Foundation
import RegexBuilder

struct Day14: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
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
