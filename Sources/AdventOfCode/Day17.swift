import Foundation
import RegexBuilder

struct Day17: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day17 {
  struct Computer {
    enum Operand: Int {
      case adv = 0
      case bxl
      case bst
      case jnz
      case bxc
      case out
      case bdv
      case cdv
    }

    var registerA: Int
    var registerB: Int
    var registerC: Int
    var program: [Operand]

    func combo(with operand: Operand) -> Int {
      switch operand {
      case .adv, .bxl, .bst, .jnz:
        return operand.rawValue
      case .bxc:
        return registerA
      case .out:
        return registerB
      case .bdv:
        return registerC
      case .cdv:
        return 0
      }
    }
  }
}

private extension String {
  var computer: Day17.Computer? {
    var registers: [String: Int] {
      let regex = Regex {
        Capture {
          One("Register ")
          OneOrMore(.word)
        }
        One(": ")
        Capture {
          OneOrMore(.digit)
        }
      }
      var dictionary: [String: Int] = [:]
      for match in matches(of: regex) {
        let output = match.output
        dictionary[String(output.1)] = Int(output.2)!
      }
      return dictionary
    }
    var program: [Int] {
      let line = split(separator: "\n\n")[1]
      let nums = line.trimmingPrefix("Program: ")
        .trimmingCharacters(in: .newlines)
        .split(separator: ",")
      return nums.map { Int(String($0))! }
    }

    guard let registerA = registers["Register A"],
      let registerB = registers["Register B"],
      let registerC = registers["Register C"]
    else {
      return nil
    }

    return Day17.Computer(
      registerA: registerA,
      registerB: registerB,
      registerC: registerC,
      program: program.compactMap(Day17.Computer.Operand.init(rawValue:)))
  }
}
