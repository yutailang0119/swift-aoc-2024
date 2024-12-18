import Foundation
import RegexBuilder

struct Day17: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day17 {
  func run(to computer: Computer) -> [Int] {
    var computer = computer
    var outputs: [Int] = []
    var instructionPointer = 0

    while instructionPointer < computer.program.count {
      let opcode = computer.program[instructionPointer]
      let operand = computer.program[instructionPointer + 1]
      var next = instructionPointer + 2

      switch opcode {
      case .adv:
        computer.registerA /= Int(pow(2.0, Double(computer.combo(with: operand))))
      case .bxl:
        computer.registerB ^= operand.rawValue
      case .bst:
        computer.registerB = computer.combo(with: operand) % 8
      case .jnz:
        if computer.registerA != 0 {
          next = operand.rawValue
        }
      case .bxc:
        computer.registerB ^= computer.registerC
      case .out:
        outputs.append(computer.combo(with: operand) % 8)
      case .bdv:
        computer.registerB = computer.registerA / Int(pow(2.0, Double(computer.combo(with: operand))))
      case .cdv:
        computer.registerC = computer.registerA / Int(pow(2.0, Double(computer.combo(with: operand))))
      }
      instructionPointer = next
    }

    return outputs
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
