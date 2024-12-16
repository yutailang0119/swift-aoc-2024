import Foundation

extension Collection {
  public subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension Collection where Index == Int {
  public var center: Element? {
    switch count {
    case 0:
      return nil
    case 1:
      return self.first
    default:
      return self[(count - 1) / 2]
    }
  }
}

extension Collection where Element: RandomAccessCollection, Element.Index == Int {
  public func transposed() -> [[Element.Element]] {
    guard !isEmpty else {
      return []
    }
    return (0...(first!.endIndex - 1))
      .map { i in
        map { $0[i] }
      }
  }
}

extension Collection where Element: Hashable {
  public var duplicates: [Element] {
    var elements = Set<Element>()
    var duplicates = Set<Element>()

    for element in self {
      if elements.contains(element) {
        duplicates.insert(element)
      } else {
        elements.insert(element)
      }
    }

    return Array(duplicates)
  }
}
