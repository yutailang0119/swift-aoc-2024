import Collections
import Foundation

struct Day24: AdventDay {
  var data: String

  func part1() async throws -> Any {
    var values: [String: Bool] = self.wires
      .reduce(into: [:]) { $0[$1.name] = $1.bool }

    var gates: Deque<Gate> = Deque(self.gates)
    while let gate = gates.popFirst() {
      guard let a = values[gate.a],
        let b = values[gate.b]
      else {
        gates.append(gate)
        continue
      }
      values[gate.output] = gate.operation.operate(a, b)
    }

    let zs = values.filter { $0.key.hasPrefix("z") }
      .sorted { $0.key > $1.key }
      .map(\.value)

    var binary = 0
    for z in zs {
      binary = (binary << 1) | (z ? 1 : 0)
    }

    return binary
  }
}

private extension Day24 {
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").map(String.init)
    }
  }

  var wires: [Wire] {
    entities[0].map {
      let splited = $0.split(separator: ": ")
      let value = Int(splited[1])!
      return Wire(name: String(splited[0]), bool: value == 1)
    }
  }

  var gates: [Gate] {
    entities[1].map {
      let splited = $0.split(separator: " ")
      return Gate(
        a: String(splited[0]),
        b: String(splited[2]),
        operation: Gate.Operation(rawValue: String(splited[1]))!,
        output: String(splited[4])
      )
    }
  }
}

private extension Day24 {
  struct Wire {
    var name: String
    var bool: Bool
  }

  struct Gate {
    enum Input {
      case x(Int)
      case y(Int)
      case gate(String)

      init(_ s: Substring) {
        switch s.first {
        case "x":
          self = .x(Int(s.dropFirst())!)
        case "y":
          self = .y(Int(s.dropFirst())!)
        default:
          self = .gate(String(s))
        }
      }
    }

    enum Operation: String {
      case and = "AND"
      case or = "OR"
      case xor = "XOR"

      func operate(_ a: Bool, _ b: Bool) -> Bool {
        switch self {
        case .and:
          return a && b
        case .or:
          return a || b
        case .xor:
          return (a || b) && !(a && b)
        }
      }
    }

    var a: String
    var b: String
    var operation: Operation
    var output: String
  }
}
