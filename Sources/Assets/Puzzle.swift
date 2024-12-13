import Foundation

enum Puzzle {}

extension Puzzle {
  struct Table<Element>: Sendable where Element: Sendable, Element: Equatable {
    var lines: [[Element]]
  }

  struct Position: Hashable {
    var x: Int
    var y: Int
  }

  struct Direction: OptionSet {
    let rawValue: Int

    static let top = Direction(rawValue: 1 << 0)
    static let bottom = Direction(rawValue: 1 << 1)
    static let left = Direction(rawValue: 1 << 2)
    static let right = Direction(rawValue: 1 << 3)
  }
}

extension Puzzle.Table: CustomStringConvertible where Element: CustomStringConvertible {
  var description: String {
    lines.map { $0.map(\.description).joined() }
      .joined(separator: "\n")
  }
}

extension Puzzle.Table {
  var count: Int {
    lines.reduce(0) { $0 + $1.count }
  }

  func element(at position: Puzzle.Position) -> Element? {
    lines[safe: position.y]?[safe: position.x]
  }

  func positions(for element: Element) -> [Puzzle.Position] {
    var positions: [Puzzle.Position] = []
    for line in lines.enumerated() {
      for e in line.element.enumerated() {
        if e.element == element {
          positions.append(Puzzle.Position(x: e.offset, y: line.offset))
        }
      }
    }
    return positions
  }

  var positions: [[(Element, Puzzle.Position)]] {
    lines.enumerated().reduce(into: [[(Element, Puzzle.Position)]]()) { lns, y in
      lns.append(
        y.element.enumerated().map {
          ($0.element, Puzzle.Position(x: $0.offset, y: y.offset))
        }
      )
    }
  }
}

extension Puzzle.Table where Element: Equatable {
  func route(
    from start: Puzzle.Position,
    to direction: Puzzle.Direction,
    until element: Element? = nil
  ) -> [Puzzle.Position] {
    var positions: [Puzzle.Position] = []
    var p = start
    var next = self.element(at: p.moved(to: direction))
    while next != nil, next != element {
      positions.append(p)
      p = p.moved(to: direction)
      next = self.element(at: p)
    }
    return positions
  }
}

extension Puzzle.Position {
  static func + (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func - (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  func moved(to direction: Puzzle.Direction) -> Self {
    switch direction {
    case .top:
      return Self(x: x, y: y - 1)
    case .bottom:
      return Self(x: x, y: y + 1)
    case .left:
      return Self(x: x - 1, y: y)
    case .right:
      return Self(x: x + 1, y: y)
    case [.top, .left]:
      return Self(x: x - 1, y: y - 1)
    case [.top, .right]:
      return Self(x: x + 1, y: y - 1)
    case [.bottom, .left]:
      return Self(x: x - 1, y: y + 1)
    case [.bottom, .right]:
      return Self(x: x + 1, y: y + 1)
    default:
      fatalError()
    }
  }
}

extension Puzzle.Direction {
  var rightDegrees: Self {
    switch self {
    case .top: return .right
    case .right: return .bottom
    case .bottom: return .left
    case .left: return .top
    default:
      fatalError()
    }
  }

  var leftDegrees: Self {
    switch self {
    case .top: return .left
    case .left: return .bottom
    case .bottom: return .right
    case .right: return .top
    default:
      fatalError()
    }
  }
}

extension Puzzle.Direction: CustomStringConvertible {
  var description: String {
    switch self {
    case .top: return ".top"
    case .bottom: return ".bottom"
    case .left: return ".left"
    case .right: return ".right"
    case [.top, .bottom]: return "[.top, .bottom]"
    case [.top, .left]: return "[.top, .left]"
    case [.top, .right]: return "[.top, .right]"
    case [.bottom, .left]: return "[.bottom, .leftt]"
    case [.bottom, .right]: return "[.bottom, .right]"
    case [.top, .bottom]: return "[.top, .bottom]"
    case [.left, .right]: return "[.left, .right]"
    case [.top, .bottom, .left]: return "[.top, .bottom, .left]"
    case [.top, .bottom, .right]: return "[.top, .bottom, .right]"
    case [.top, .left, .right]: return "[.top, .left, .right]"
    case [.bottom, .left, .right]: return "[.bottom, .left, .right]"
    case [.top, .bottom, .left, .right]: return "[.top, .bottom, .left, .right]"
    default: return ""
    }
  }
}
