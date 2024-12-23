import Foundation
import ToolKit

struct Day21: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let inputs = entities.map(Input.init)

    let keypadSequences = self.keypadSequences

    var memo: [DirectionalContext: Int] = [:]

    return press(
      inputs: inputs,
      depth: 3,
      numberKeypadSequences: keypadSequences.numeric,
      directionalKeypadSequences: keypadSequences.directional,
      memo: &memo
    )
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let inputs = entities.map(Input.init)

    let keypadSequences = self.keypadSequences

    var memo: [DirectionalContext: Int] = [:]

    return press(
      inputs: inputs,
      depth: 26,
      numberKeypadSequences: keypadSequences.numeric,
      directionalKeypadSequences: keypadSequences.directional,
      memo: &memo
    )
  }
}

private extension Day21 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  var keypadSequences:
    (
      numeric: [SequenceKey<NumericKeypad>: [[DirectionalKeypad]]],
      directional: [SequenceKey<DirectionalKeypad>: [[DirectionalKeypad]]]
    )
  {
    func steps<Keypad>(
      start: Keypad,
      end: Keypad,
      in dictionary: [Position: Keypad],
      visited: Set<Keypad>
    ) -> [[DirectionalKeypad]] {
      guard start != end else {
        return [[.a]]
      }
      let position = dictionary.first { $0.value == start }!.key

      var outputs: [[DirectionalKeypad]] = []
      for direction in [Direction.top, .bottom, .left, .right] {
        guard let next = dictionary[position.moved(to: direction)] else {
          continue
        }
        if !visited.contains(next) {
          let steps = steps(start: next, end: end, in: dictionary, visited: visited.union([start]))
          let k = DirectionalKeypad(direction: direction)
          outputs.append(contentsOf: steps.map { [k] + $0 })
        }
      }
      return outputs
    }

    let numeric = {
      /*
       +---+---+---+
       | 7 | 8 | 9 |
       +---+---+---+
       | 4 | 5 | 6 |
       +---+---+---+
       | 1 | 2 | 3 |
       +---+---+---+
           | 0 | A |
           +---+---+
       */
      let keypads: [Position: NumericKeypad] = [
        Position(x: 0, y: 0): .seven, Position(x: 1, y: 0): .eight, Position(x: 2, y: 0): .nine,
        Position(x: 0, y: 1): .four, Position(x: 1, y: 1): .five, Position(x: 2, y: 1): .six,
        Position(x: 0, y: 2): .one, Position(x: 1, y: 2): .two, Position(x: 2, y: 2): .three,
        Position(x: 1, y: 3): .zero, Position(x: 2, y: 3): .a,
      ]
      var sequences: [SequenceKey<NumericKeypad>: [[DirectionalKeypad]]] = [:]
      let numerics = NumericKeypad.allCases
      for start in numerics {
        for end in numerics {
          sequences[SequenceKey(start: start, end: end)] = steps(start: start, end: end, in: keypads, visited: [])
        }
      }
      return sequences
    }()
    let directional = {
      /*
           +---+---+
           | ^ | A |
       +---+---+---+
       | < | v | > |
       +---+---+---+
       */
      let keypads: [Position: DirectionalKeypad] = [
        Position(x: 1, y: 0): .up, Position(x: 2, y: 0): .a,
        Position(x: 0, y: 1): .left, Position(x: 1, y: 1): .down, Position(x: 2, y: 1): .right,
      ]

      var sequences: [SequenceKey<DirectionalKeypad>: [[DirectionalKeypad]]] = [:]
      let directionals = DirectionalKeypad.allCases
      for start in directionals {
        for end in directionals {
          sequences[SequenceKey(start: start, end: end)] = steps(start: start, end: end, in: keypads, visited: [])
        }
      }
      return sequences
    }()

    return (numeric, directional)
  }
}

private extension Day21 {
  func press(
    inputs: [Input],
    depth: Int,
    numberKeypadSequences: [SequenceKey<NumericKeypad>: [[DirectionalKeypad]]],
    directionalKeypadSequences: [SequenceKey<DirectionalKeypad>: [[DirectionalKeypad]]],
    memo: inout [DirectionalContext: Int]
  ) -> Int {
    var sum = 0
    for input in inputs {
      var previous: NumericKeypad = .a
      var count = 0
      for keypad in input.keypads {
        count += numericKeypad(
          numberKeypadSequences: numberKeypadSequences,
          directionalKeypadSequences: directionalKeypadSequences,
          context: NumericContext(previous: previous, current: keypad, depth: depth),
          memo: &memo
        )
        previous = keypad
      }
      sum += count * input.number
    }
    return sum
  }

  func numericKeypad(
    numberKeypadSequences: [SequenceKey<NumericKeypad>: [[DirectionalKeypad]]],
    directionalKeypadSequences: [SequenceKey<DirectionalKeypad>: [[DirectionalKeypad]]],
    context: NumericContext,
    memo: inout [DirectionalContext: Int]
  ) -> Int {
    var output: Int? = nil
    for keypads in numberKeypadSequences[SequenceKey(start: context.previous, end: context.current)]! {
      var previous = DirectionalKeypad.a
      var count = 0
      for keypad in keypads {
        count += directionalKeypad(
          sequences: directionalKeypadSequences,
          context: DirectionalContext(previous: previous, current: keypad, depth: context.depth - 1),
          memo: &memo
        )
        previous = keypad
      }
      if output.map({ $0 > count }) ?? true {
        output = count
      }
    }
    return output ?? 0
  }

  func directionalKeypad(
    sequences: [SequenceKey<DirectionalKeypad>: [[DirectionalKeypad]]],
    context: DirectionalContext,
    memo: inout [DirectionalContext: Int]
  ) -> Int {
    if let directional = memo[context] {
      return directional
    }
    if context.depth == 0 {
      return 1
    }

    var output: Int? = nil
    for steps in sequences[SequenceKey(start: context.previous, end: context.current)]! {
      var previous = DirectionalKeypad.a
      var count = 0
      for step in steps {
        count += directionalKeypad(
          sequences: sequences,
          context: DirectionalContext(previous: previous, current: step, depth: context.depth - 1),
          memo: &memo
        )
        previous = step
      }
      if output.map({ $0 > count }) ?? true {
        output = count
      }
    }
    memo[context] = output
    return output ?? 0
  }
}

private extension Day21 {
  struct Input {
    var rawValue: String

    var keypads: [NumericKeypad] {
      rawValue.compactMap(NumericKeypad.init(rawValue:))
    }

    var number: Int {
      Int(String(rawValue.dropLast(1))) ?? 0
    }
  }

  enum NumericKeypad: Character, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case a = "A"
  }

  struct NumericContext: Hashable {
    var previous: NumericKeypad
    var current: NumericKeypad
    var depth: Int
  }

  enum DirectionalKeypad: Character, CaseIterable {
    case up = "^"
    case left = "<"
    case down = "v"
    case right = ">"
    case a = "A"

    init(direction: Direction) {
      switch direction {
      case .top: self = .up
      case .bottom: self = .down
      case .left: self = .left
      case .right: self = .right
      default: fatalError()
      }
    }
  }

  struct DirectionalContext: Hashable {
    var previous: DirectionalKeypad
    var current: DirectionalKeypad
    var depth: Int
  }

  struct SequenceKey<Keypad: Hashable>: Hashable {
    var start: Keypad
    var end: Keypad
  }
}
