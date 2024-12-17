public struct Direction: OptionSet, Sendable {
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
    case .top: return .right
    case .right: return .bottom
    case .bottom: return .left
    case .left: return .top
    default:
      fatalError()
    }
  }

  var counterClockwise: Self {
    switch self {
    case .top: return .left
    case .left: return .bottom
    case .bottom: return .right
    case .right: return .top
    default:
      fatalError()
    }
  }

  var reverse: Self {
    switch self {
    case .top: return .bottom
    case .bottom: return .top
    case .left: return .right
    case .right: return .left
    default:
      fatalError()
    }
  }
}

extension Direction: CustomStringConvertible {
  public var description: String {
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
