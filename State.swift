import Foundation

class State: Identifiable, CustomStringConvertible {
    var id: String
    var transitions = [String:[String]]()

    init(id: String) {
        self.id = id
    }

    var description: String {
        return id
    }

    func addTransition(on symbol: String, to stateID: String) {
        if transitions[symbol] == nil {
            transitions[symbol] = [stateID]
        } else {
            transitions[symbol]!.append(stateID)
        }
        Log.debug("\(self) transitions on \(symbol): \(transitions[symbol]!)")
    }

    func getUniqueTransition(symbol: String) -> String? {
        if let targetIds = transitions[symbol] {
            if targetIds.count > 1 {
                Log.fatal("more than one target ID specified for unique transition in state \(self) on symbol \(symbol)")
            }
            return targetIds.first

        } else {
            Log.fatal("missing transition on symbol '\(symbol)' from state '\(self)'")
            return nil // never reached
        }
    }
}

