public struct Direction: OptionSet, Hashable, Sendable {
  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public static let top = Direction(rawValue: 1 << 0)
  public static let bottom = Direction(rawValue: 1 << 1)
  public static let left = Direction(rawValue: 1 << 2)
  public static let right = Direction(rawValue: 1 << 3)
}

public extension Direction {
  var clockwise: Self {
    switch self {
    case .top: .right
    case .right: .bottom
    case .bottom: .left
    case .left: .top
    default: fatalError()
    }
  }

  var counterClockwise: Self {
    switch self {
    case .top: .left
    case .left: .bottom
    case .bottom: .right
    case .right: .top
    default: fatalError()
    }
  }

  var reverse: Self {
    switch self {
    case .top: .bottom
    case .bottom: .top
    case .left: .right
    case .right: .left
    default:
      fatalError()
    }
  }
}

extension Direction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .top: ".top"
    case .bottom: ".bottom"
    case .left: ".left"
    case .right: ".right"
    case [.top, .bottom]: "[.top, .bottom]"
    case [.top, .left]: "[.top, .left]"
    case [.top, .right]: "[.top, .right]"
    case [.bottom, .left]: "[.bottom, .leftt]"
    case [.bottom, .right]: "[.bottom, .right]"
    case [.top, .bottom]: "[.top, .bottom]"
    case [.left, .right]: "[.left, .right]"
    case [.top, .bottom, .left]: "[.top, .bottom, .left]"
    case [.top, .bottom, .right]: "[.top, .bottom, .right]"
    case [.top, .left, .right]: "[.top, .left, .right]"
    case [.bottom, .left, .right]: "[.bottom, .left, .right]"
    case [.top, .bottom, .left, .right]: "[.top, .bottom, .left, .right]"
    default: ""
    }
  }
}
