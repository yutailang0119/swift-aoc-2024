import Foundation
import RegexBuilder

struct Day13: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let machines = entities.compactMap(\.machine)

    var sum = 0
    for machine in machines {
      let i = machine.prize.x * machine.b.y - machine.prize.y * machine.b.x
      let j = machine.a.x * machine.b.y - machine.a.y * machine.b.x
      let pushingA = Double(i) / Double(j)
      let pushingB = (Double(machine.prize.y) - pushingA * Double(machine.a.y)) / Double(machine.b.y)
      if pushingA.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne)
        && pushingB.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne)
      {
        sum += Int(pushingA * 3 + pushingB)
      }
    }

    return sum
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
      let i = prize.x * b.y - prize.y * b.x
      let j = a.x * b.y - a.y * b.x
      let pushingA = Double(i) / Double(j)
      let pushingB = (Double(prize.y) - pushingA * Double(a.y)) / Double(b.y)
      if pushingA.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne)
        && pushingB.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne)
      {
        return Int(pushingA * 3 + pushingB)
      } else {
        return 0
      }
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
