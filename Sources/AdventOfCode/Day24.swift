import Collections
import Foundation

struct Day24: AdventDay {
  var data: String

  func part1() async throws -> Any {
    var xs: [Bool] = []
    var ys: [Bool] = []
    for wire in self.wires.sorted(by: { $0.name < $1.name }) {
      switch wire.name.first {
      case "x":
        xs.append(wire.bool)
      case "y":
        ys.append(wire.bool)
      default:
        continue
      }
    }

    var gates: [String: Gate] = self.gates
    var binary = 0
    let zs = gates.filter { $0.key.hasPrefix("z") }
      .sorted { $0.key > $1.key }
    for z in zs {
      let zValue = value(z.key, caching: nil, xs: xs, ys: ys, in: &gates)
      binary = (binary << 1) | zValue.int
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

  var gates: [String: Gate] {
    let gates = entities[1].map {
      let splited = $0.split(separator: " ")
      return Gate(
        a: Gate.Input(splited[0]),
        b: Gate.Input(splited[2]),
        operation: Gate.Operation(rawValue: String(splited[1]))!,
        output: String(splited[4])
      )
    }
    return gates.reduce(into: [:]) { $0[$1.output] = $1 }
  }

  func value(
    _ string: String,
    caching: Int?,
    xs: [Bool],
    ys: [Bool],
    in gates: inout [String: Gate]
  ) -> Bool {
    let gate = gates[string]!
    var cache = false
    if let caching,
      let high = gate.dependency,
      high < caching
    {
      if let cached = gate.cached {
        return cached
      }
      cache = true
    }
    let a = value(for: gate.a, caching: caching, xs: xs, ys: ys, in: &gates)
    let b = value(for: gate.b, caching: caching, xs: xs, ys: ys, in: &gates)
    let binary = gate.operation.operate(a, b)
    if cache {
      gates[string]!.cached = binary
    }
    return binary
  }

  func value(
    for input: Gate.Input,
    caching: Int?,
    xs: [Bool],
    ys: [Bool],
    in gates: inout [String: Gate]
  ) -> Bool {
    switch input {
    case .x(let i):
      return xs[i]
    case .y(let i):
      return ys[i]
    case .gate(let string):
      return value(string, caching: caching, xs: xs, ys: ys, in: &gates)
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

    var a: Input
    var b: Input
    var operation: Operation
    var output: String
    var cached: Bool?
    var dependency: Int?
  }
}

private extension Bool {
  var int: Int {
    self ? 1 : 0
  }
}

private extension Int {
  var bit: String {
    self < 10 ? "0\(self)" : "\(self)"
  }
}
