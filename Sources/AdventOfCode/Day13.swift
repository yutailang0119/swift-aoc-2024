import Foundation
import RegexBuilder

struct Day13: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let machines = entities.compactMap(\.machine)

    return machines.reduce(0) { $0 + $1.token }
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let machines = entities.compactMap(\.machine)
      .map {
        Machine(a: $0.a, b: $0.b, prize: Machine.Claw(x: $0.prize.x + 10000000000000, y: $0.prize.y + 10000000000000))
      }

    return machines.reduce(0) { $0 + $1.token }
  }
}

private extension Day13 {
  var entities: [String] {
    data.split(separator: "\n\n")
      .map(String.init)
  }
}

private extension Day13 {
  struct Machine {
    struct Claw {
      var x: Int
      var y: Int
    }

    var a: Claw
    var b: Claw
    var prize: Claw

    var token: Int {
      guard (a.y * b.x - b.y * a.x) != 0,
        (prize.y * a.x - a.y * prize.x) % (b.y * a.x - a.y * b.x) == 0
      else {
        return 0
      }
      let pushingA = (prize.y * b.x - b.y * prize.x) / (a.y * b.x - b.y * a.x)
      guard (prize.x - a.x * pushingA) % b.x == 0 else {
        return 0
      }
      let pushingB = (prize.x - a.x * pushingA) / b.x

      return pushingA * 3 + pushingB
    }
  }
}

private extension String {
  var machine: Day13.Machine? {
    let regex = Regex {
      Capture {
        ChoiceOf {
          One("Button A")
          One("Button B")
          One("Prize")
        }
      }
      One(": ")
      Capture {
        ChoiceOf {
          One("X+")
          One("X=")
        }
        Capture {
          OneOrMore(.digit)
        }
      }
      One(", ")
      Capture {
        ChoiceOf {
          One("Y+")
          One("Y=")
        }
        Capture {
          OneOrMore(.digit)
        }
      }
    }

    var dictionary: [String: (x: Int, y: Int)] = [:]
    for match in matches(of: regex) {
      let output = match.output
      dictionary[String(output.1)] = (x: Int(output.3)!, y: Int(output.5)!)
    }

    guard let buttonA = dictionary["Button A"],
      let buttonB = dictionary["Button B"],
      let prize = dictionary["Prize"]
    else {
      return nil
    }

    return Day13.Machine(
      a: Day13.Machine.Claw(x: buttonA.x, y: buttonA.y),
      b: Day13.Machine.Claw(x: buttonB.x, y: buttonB.y),
      prize: Day13.Machine.Claw(x: prize.x, y: prize.y)
    )
  }
}
