import Foundation

class NFA: FSM {
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
        return true
    }
}

