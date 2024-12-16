public struct Position: Hashable, Sendable {
  public var x: Int
  public var y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

public extension Position {
  static func + (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func - (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  func moved(to direction: Direction) -> Self {
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
