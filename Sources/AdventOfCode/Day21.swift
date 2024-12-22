import Foundation
import ToolKit

struct Day21: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
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
      let keypads = [
        Position(x: 0, y: 0): NumericKeypad.seven, Position(x: 1, y: 0): NumericKeypad.eight,
        Position(x: 2, y: 0): NumericKeypad.nine,
        Position(x: 0, y: 1): NumericKeypad.four, Position(x: 1, y: 1): NumericKeypad.five,
        Position(x: 2, y: 1): NumericKeypad.six,
        Position(x: 0, y: 2): NumericKeypad.one, Position(x: 1, y: 2): NumericKeypad.two,
        Position(x: 2, y: 2): NumericKeypad.three,
        Position(x: 1, y: 3): NumericKeypad.zero, Position(x: 2, y: 3): NumericKeypad.a,
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
      let keypads = [
        Position(x: 1, y: 0): DirectionalKeypad.up, Position(x: 2, y: 0): DirectionalKeypad.a,
        Position(x: 0, y: 1): DirectionalKeypad.left, Position(x: 1, y: 1): DirectionalKeypad.down,
        Position(x: 2, y: 1): DirectionalKeypad.right,
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

  enum DirectionalKeypad: Character, CaseIterable {
    case up = "^"
    case left = "<"
    case down = "v"
    case right = ">"
    case a = "A"

    init?(rawValue: Character) {
      switch rawValue {
      case "^": self = .up
      case "<": self = .left
      case "v": self = .down
      case ">": self = .right
      case "A": self = .a
      default: return nil
      }
    }

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
}
