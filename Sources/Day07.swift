import Foundation

struct Day07: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n")
      .map(String.init)
  }

  func part1() async throws -> Any {
    let equations = self.equations
    var sum = 0
    for equation in equations {
      var numbers = equation.numbers
      let first = numbers.removeFirst()
      let calculates = calculate(from: first, for: numbers, by: [.add, .multiple])
      if calculates.contains(equation.test) {
        sum += equation.test
      }
    }
    return sum
  }

  func part2() async throws -> Any {
    let equations = self.equations
    var sum = 0
    for equation in equations {
      var numbers = equation.numbers
      let first = numbers.removeFirst()
      let calculates = calculate(from: first, for: numbers, by: [.add, .multiple, .concatenation])
      if calculates.contains(equation.test) {
        sum += equation.test
      }
    }
    return sum
  }

  private func calculate(from num: Int, for numbers: [Int], by operators: [Operator]) -> [Int] {
    guard !numbers.isEmpty else {
      return [num]
    }
    var remains = numbers
    let rhs = remains.removeFirst()

    var calculated: [Int] = []
    for `operator` in operators {
      switch `operator` {
      case .add:
        calculated.append(
          contentsOf: calculate(from: num + rhs, for: remains, by: operators)
        )
      case .multiple:
        calculated.append(
          contentsOf: calculate(from: num * rhs, for: remains, by: operators)
        )
      case .concatenation:
        calculated.append(
          contentsOf: calculate(from: Int("\(num)\(rhs)")!, for: remains, by: operators)
        )
      }
    }
    return calculated
  }

  private var equations: [Equation] {
    entities.compactMap {
      let splited =  $0.split(separator: ": ")
      guard let test = Int(splited[0]) else {
        return nil
      }
      let numbers = splited[1].split(separator: " ").compactMap { Int($0) }
      return Equation(test: test, numbers: numbers)
    }
  }
}

private extension Day07 {
  struct Equation {
    var test: Int
    var numbers: [Int]
  }

  enum Operator {
    case add
    case multiple
    case concatenation
  }
}
