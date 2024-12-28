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

  func part2() async throws -> Any {
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
    var corrects: Set<Int> = []
    var outputs: [[String]] = Array(repeating: [], count: xs.count)
    var dependencies: [String: Set<String>] = [:]

    let swaps = swaps(
      depth: 0,
      corrects: &corrects,
      outputs: &outputs,
      dependencies: &dependencies,
      xs: &xs,
      ys: &ys,
      in: &gates
    )
    assert(swaps?.count == 8)

    return swaps?.sorted().joined(separator: ",") ?? ""
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
      let dependency = gate.dependency,
       dependency < caching
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

  func swaps(
    depth: Int,
    corrects: inout Set<Int>,
    outputs: inout [[String]],
    dependencies: inout [String: Set<String>],
    xs: inout [Bool],
    ys: inout [Bool],
    in gates: inout [String: Gate]
  ) -> [String]? {
    corrects = self.corrects(
      xs: &xs,
      ys: &ys,
      in: &gates
    )
    guard corrects.count <= xs.count else {
      return []
    }

    outputs = Array(repeating: [], count: xs.count)
    dependencies = [:]

    let possibles = possibles(
      corrects: corrects,
      outputs: &outputs,
      dependencies: &dependencies,
      xs: &xs,
      ys: &ys,
      in: &gates
    )
    for possible in possibles {
      let a = gates[possible.a]!
      let b = gates[possible.b]!
      gates[possible.a] = b
      gates[possible.b] = a
      if let swaps = swaps(
        depth: depth + 1,
        corrects: &corrects,
        outputs: &outputs,
        dependencies: &dependencies,
        xs: &xs,
        ys: &ys,
        in: &gates
      ) {
        return [possible.a, possible.b] + swaps
      }
      gates[possible.a] = a
      gates[possible.b] = b
    }
    return nil
  }

  func corrects(
    xs: inout [Bool],
    ys: inout [Bool],
    in gates: inout [String: Gate]
  ) -> Set<Int> {
    var bits: Set<Int> = []
    for i in 0...xs.count {
      if simulateBit(i, caching: false, xs: &xs, ys: &ys, in: &gates) {
        bits.insert(i)
      }
    }
    return bits
  }

  func possibles(
    corrects: Set<Int>,
    outputs: inout [[String]],
    dependencies: inout [String: Set<String>],
    xs: inout [Bool],
    ys: inout [Bool],
    in gates: inout [String: Gate]
  ) -> [(a: String, b: String)] {
    func _simulateBits(_ bit: Int) -> Bool {
      guard simulateBit(bit, caching: true, xs: &xs, ys: &ys, in: &gates) else {
        return false
      }
      for bit in corrects {
        guard simulateBit(bit, caching: true, xs: &xs, ys: &ys, in: &gates) else {
          return false
        }
      }
      return true
    }
    func _gates(input: Gate.Input) -> (gates: Set<String>, index: Int) {
      switch input {
      case .x(let index), .y(let index):
        return ([], index)
      case .gate(let output):
        return _gates(output: output)
      }
    }
    func _gates(output: String) -> (gates: Set<String>, index: Int) {
      var gate = gates[output]!
      if let index = gate.dependency {
        return (dependencies[output]!, index)
      }
      let (gateA, indexA) = _gates(input: gate.a)
      let (gateB, indexB) = _gates(input: gate.b)
      let dependency = gateA.union(gateB).union([output])
      let index = max(indexA, indexB)
      gate.dependency = index
      gate.cached = nil
      gates[output] = gate
      dependencies[output] = dependency
      outputs[index].append(output)
      return (dependency, index)
    }

    for key in gates.keys {
      gates[key]!.cached = nil
      gates[key]!.dependency = nil
    }
    for key in gates.keys {
      _ = _gates(output: key)
    }

    var swaps: [(a: String, b: String)] = []
    for index in 0...xs.count where !corrects.contains(index) {
      for a in dependencies["z\(index.bit)"]! {
        let targetA = dependencies[a]!
        for b in outputs[index] where !targetA.contains(b) {
          let targetB = dependencies[b]!
          guard !targetB.contains(a) else {
            continue
          }
          let gateA = gates[a]!
          let gateB = gates[b]!
          gates[a] = gateB
          gates[b] = gateA
          if _simulateBits(index) {
            swaps.append((a, b))
          }
          gates[a] = gateA
          gates[b] = gateB
        }
      }
    }
    return swaps
  }

  func simulateBit(
    _ bit: Int,
    caching: Bool,
    xs: inout [Bool],
    ys: inout [Bool],
    in gates: inout [String: Gate]
  ) -> Bool {
    let gate = "z\(bit.bit)"
    switch bit {
    case 0:
      for x in [0, 1] {
        xs[bit] = x == 1
        for y in [0, 1] {
          ys[bit] = y == 1
          let zValue = value(gate, caching: nil, xs: xs, ys: ys, in: &gates)
          guard (x + y) & 1 == zValue.int else {
            return false
          }
        }
      }
    case xs.count:
      for i in [0, 1] {
        xs[bit - 1] = i == 1
        ys[bit - 1] = i == 1
        let zValue = value(gate, caching: caching ? bit - 1 : nil, xs: xs, ys: ys, in: &gates)
        guard i == zValue.int else {
          return false
        }
      }
    default:
      for i in [0, 1] {
        xs[bit - 1] = i == 1
        ys[bit - 1] = i == 1
        for x in [0, 1] {
          xs[bit] = x == 1
          for y in [0, 1] {
            ys[bit] = y == 1
            let zValue = value(gate, caching: caching ? bit - 1 : nil, xs: xs, ys: ys, in: &gates)
            guard (x + y + i) & 1 == zValue.int else {
              return false
            }
          }
        }
      }
    }
    return true
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
