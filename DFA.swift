import Foundation

class DFA: FSM, CustomStringConvertible {
    var currentState: State
    var states: [State]
    var acceptingStates: [State]
    var initialState: State

    init(states: [State], acceptingStates: [State], initialState: State) {
        self.states = states
        self.acceptingStates = acceptingStates
        self.initialState = initialState
        self.currentState = initialState
    }

    var description: String {
        var s = "DFA:\n"
        s += "\tstates: \(states)\n"
        s += "\tinitial state: \(initialState)\n"
        s += "\taccepting states: \(acceptingStates)\n"
        s += "\ttransitions:\n"
        return s
    }

    func reset() {
        self.currentState = initialState
    }

    func process(_ input: [String]) -> Bool {
        reset()
        for symbol in input {
            if let targetId = currentState.transitions[symbol], let targetIndex = states.firstIndex(where: {$0.id == targetId}) {
                currentState = states[targetIndex]
                Log.debug("\(symbol) -> \(currentState)")
            } else {
                Log.fatal("missing transition on symbol '\(symbol)' from state '\(currentState.id)'")
                return false
            }
        }
        Log.note("ended in state \(currentState)")
        return acceptingStates.contains(where: {$0.id == currentState.id})
    }
}

class State: Identifiable, CustomStringConvertible {
    var id: String
    var transitions = [String:String]()

    init(id: String) {
        self.id = id
    }

    var description: String {
        return id
    }

    func addTransition(on symbol: String, to state: String) {
        transitions[symbol] = state
    }
}

