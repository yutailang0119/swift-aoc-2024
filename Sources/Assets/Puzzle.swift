enum Puzzle {}

extension Puzzle {
  struct Table<Element: Equatable> {
    var lines: [[Element]]

    func element(at position: Position) -> Element? {
      lines[safe: position.y]?[safe: position.x]
    }

    func positions(for element: Element) -> [Position] {
      var positions: [Position] = []
      for line in lines.enumerated() {
        for e in line.element.enumerated() {
          if e.element == element {
            positions.append(Position(x: e.offset, y: line.offset))
          }
        }
      }
      return positions
    }
  }

  struct Position {
    var x: Int
    var y: Int

    func moved(to direction: Direction) -> Position {
      switch direction {
      case .top:
        return Position(x: x, y: y - 1)
      case .bottom:
        return Position(x: x, y: y + 1)
      case .left:
        return Position(x: x - 1, y: y)
      case .right:
        return Position(x: x + 1, y: y)
      case [.top, .left]:
        return Position(x: x - 1, y: y - 1)
      case [.top, .right]:
        return Position(x: x + 1, y: y - 1)
      case [.bottom, .left]:
        return Position(x: x - 1, y: y + 1)
      case [.bottom, .right]:
        return Position(x: x + 1, y: y + 1)
      default:
        fatalError()
      }
    }
  }

  struct Direction: OptionSet {
    let rawValue: Int

    static let top = Direction(rawValue: 1 << 0)
    static let bottom = Direction(rawValue: 1 << 1)
    static let left = Direction(rawValue: 1 << 2)
    static let right = Direction(rawValue: 1 << 3)
  }
}
