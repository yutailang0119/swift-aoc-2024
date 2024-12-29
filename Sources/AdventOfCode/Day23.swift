import Collections
import Foundation

struct Day23: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let computers = self.computers

    var networks: Set<Set<String>> = []
    for computer in computers.filter({ $0.key.hasPrefix("t") }) {
      for combination in computer.value.connections.combinations(ofCount: 2) {
        let a = combination[0]
        let b = combination[1]
        if computers[a]!.connections.contains(b) {
          networks.insert([computer.key, a, b])
        }
      }
    }

    return networks.count
  }

  func part2() async throws -> Any {
    let connections = self.connections
    let computers = self.computers

    var networks: Set<Set<String>> = []
    for computer in computers {
      if networks.contains(where: { $0.contains(computer.key) }) {
        continue
      }
      networks.insert(
        network(from: computer.value, in: connections)
      )
    }

    return networks.max { $0.count < $1.count }!
      .sorted()
      .joined(separator: ",")
  }
}

private extension Day23 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  var connections: [Connection] {
    let entities = self.entities

    return entities.map { entity in
      let splited = entity.split(separator: "-")
      return Connection(a: String(splited[0]), b: String(splited[1]))
    }
  }

  var computers: [String: Computer] {
    let connections = self.connections

    var computers: [String: Computer] = [:]
    for connection in connections {
      computers[
        connection.a,
        default: Computer(name: connection.a, connections: [])
      ].connections.insert(connection.b)
      computers[
        connection.b,
        default: Computer(name: connection.b, connections: [])
      ].connections.insert(connection.a)
    }

    return computers
  }

  func network(from start: Computer, in connections: [Connection]) -> Set<String> {
    var network: Set<String> = [start.name]
    var deque: Deque<String> = [start.name]
    while let dq = deque.popFirst() {
      var nexts = Set(
        connections
          .compactMap { $0.remaining(dq) }
          .filter { !network.contains($0) && $0.isConnected(to: network, in: connections) }
      )
      network.formUnion(nexts)

      for n in network {
        if !n.isConnected(to: network, in: connections) {
          network.remove(n)
          nexts.remove(n)
        }
      }
      deque.append(contentsOf: nexts)
    }

    return network
  }
}

private extension Day23 {
  struct Connection {
    var a: String
    var b: String

    func remaining(_ name: String) -> String? {
      if name == a {
        return b
      } else if name == b {
        return a
      } else {
        return nil
      }
    }
  }

  struct Computer {
    var name: String
    var connections: Set<String>
  }
}

private extension String {
  func isConnected(to network: Set<String>, in connections: [Day23.Connection]) -> Bool {
    network.allSatisfy { n in
      self == n
        || connections.contains { ($0.a == self && $0.b == n) || ($0.a == n && $0.b == self) }
    }
  }
}
