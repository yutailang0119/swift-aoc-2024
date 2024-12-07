enum Puzzle {}

extension Puzzle {
  struct Table<Element: Equatable> {
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
}

extension Puzzle.Table where Element: Equatable {
  func route(from start: Puzzle.Position, to direction: Puzzle.Direction, until element: Element? = nil) -> [Puzzle.Position] {
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
